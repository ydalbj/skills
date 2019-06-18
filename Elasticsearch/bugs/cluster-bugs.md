##### 索引其中一个分片主从分片都变为unassigned

  Elasticsearch相关设置
  * 2个节点
  * 1个副本（每个分片有一个副本）
  * 索引名为：v12_goods_2019-06

  用集群健康api检查分片问题,确认分片1状态为unassigned状态

  ```
  GET _cluster/health/v12_goods_2019-06?level=shards
  ```

  用集群状态api检查索引分片情况及原因

  ```
  GET _cluster/state/routing_table/v12_goods_2019-06
  ```

  获取结果

  ```json
          "1": [
            {
              "state": "UNASSIGNED",
              "primary": true,
              "node": null,
              "relocating_node": null,
              "shard": 1,
              "index": "v12_goods_2019-06",
              "recovery_source": {
                "type": "EXISTING_STORE",
                "bootstrap_new_history_uuid": false
              },
              "unassigned_info": {
                "reason": "ALLOCATION_FAILED",
                "at": "2019-06-17T07:10:45.253Z",
                "failed_attempts": 5,
                "delayed": false,
                "details": "failed shard on node [ArAH-HuqTx-J3uMfuvL4wA]: failed to create shard, failure IOException[failed to obtain in-memory shard lock]; nested: ShardLockObtainFailedException[[v12_goods_2019-06][1]: obtaining shard lock timed out after 5000ms]; ",
                "allocation_status": "deciders_no"
              }
            },
            {
              "state": "UNASSIGNED",
              "primary": false,
              "node": null,
              "relocating_node": null,
              "shard": 1,
              "index": "v12_goods_2019-06",
              "recovery_source": {
                "type": "PEER"
              },
              "unassigned_info": {
                "reason": "REPLICA_ADDED",
                "at": "2019-06-17T09:05:11.581Z",
                "delayed": false,
                "allocation_status": "no_attempt"
              }
            }
          ],
  ```

  用集群reroute接口（retry_failed=true）重新路由失败分片
  ```
  POST _cluster/reroute?retry_failed=true
  ```

##### 索引分片副本一直处于初始化状态


  Elasticsearch相关设置
  * 2个节点
  * 1个副本（每个分片有一个副本）
  * 索引名为：v12_goods_2019-01

  使用集群状态api检查索引分片状态
  ```
  GET _cluster/state/routing_table/v12_goods_2019-01
  ```

  结果，主分片正常，副本分片一直处于初始化状态
  ```json
  "0": [
            {
              "state": "STARTED",
              "primary": true,
              "node": "k5cvjHLXQdub44v71_fRzQ",
              "relocating_node": null,
              "shard": 0,
              "index": "v12_goods_2019-01",
              "allocation_id": {
                "id": "Tk0OzmRQTS6Nbr7bR_hOqw"
              }
            },
            {
              "state": "INITIALIZING",
              "primary": false,
              "node": "ArAH-HuqTx-J3uMfuvL4wA",
              "relocating_node": null,
              "shard": 0,
              "index": "v12_goods_2019-01",
              "recovery_source": {
                "type": "PEER"
              },
              "allocation_id": {
                "id": "78qAHTLTSl6NcVP7wa87Mg"
              },
              "unassigned_info": {
                "reason": "REPLICA_ADDED",
                "at": "2019-06-17T09:35:14.166Z",
                "delayed": false,
                "allocation_status": "no_attempt"
              }
            }
          ]
  ```

  将索引副本设置为0， number_of_replicas:0。一段时间后，副本设置又重新变为1。

  调查代码，在进行bulk操作时，为了加快导入，将副本设置为0，导入结束后又重新设置为1。副本设置在0，1之间变换，导致副本一致在初始化状态。

  修改代码，不在反复设置number_of_replicas，问题解决。
