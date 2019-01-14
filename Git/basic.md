### Git命令使用技巧总结

##### 基本概念

  * Git three trees

    > Git存储库的三种状态管理机制: 工作区(the working directory), 暂存区(the staged snapshot), and 提交历史(the commit history)。这种状态机制被称为`Git三棵树`(`Git three trees`)。


##### 重置，检出和回滚操作

  > 下表总结了回滚命令(git reset, git revert, git checkout)的常见用例

  Command |	Scope |	Common use cases
  --|--|--
  git reset |	Commit-level |	Discard commits in a private branch or throw away uncommited changes
  git reset |	File-level |	Unstage a file
  git checkout |	Commit-level |	Switch between branches or inspect old snapshots
  git checkout |	File-level |	Discard changes in the working directory
  git revert |	Commit-level |	Undo commits in a public branch
  git revert |	File-level |	(N/A)

* `commit`级别操作
  - `git reset`重置特定提交

    ```
    git reset HEAD~2
    ```
    - `--soft`: 暂存区和工作区不会修改
    - `--mixed`: 暂存区被更新，工作区不受影响
    - `--hard`: 暂存区和工作区都被更新

  - `git checkout`检出历史提交
    ```
    git checkout hotfix
    ```
    > 与git reset不同，git checkout不会移动任何分支。

    > 还可以通过传递提交引用而不是分支来检出任意提交
    ```
    git checkout HEAD~2
    ```
      这对于快速检查项目的旧版本很有用。但是，由于当前HEAD没有分支引用，因此会使您处于分离的HEAD状态。如果您开始添加新提交，这可能会很危险，因为切换到另一个分支后将无法返回到它们。

  - `git revert`使用还原撤消公共提交

    通过创建新提交来还原撤消提交。这是一种撤消更改的安全方法，因为它不会重写提交历史记录。
    ```
    git revert HEAD~2
    ```

    > 使用`git revert`回滚公共分支，使用`git reset`回滚私有分支

    > 与git checkout一样，git revert有可能覆盖工作目录中的文件，因此它会要求您提交(`git commit`)或存储(`git stash`)在还原操作期间丢失的更改。

* 文件级别操作

  `git reset`和`git checkout`命令也接受可选的文件路径作为参数。这极大地改变了他们的行为。这会强制他们将操作限制为单个文件，而不是对整个快照进行操作。

  - Git重置特定文件
    ```
    git reset HEAD~2 foo.py
    ```
    > --soft， - mix和--hard标志对git reset的文件级版本没有任何影响，因为`暂存区`总是更新，并且`工作区`永远不会更新。

    ```
    git reset HEAD foo.py
    ```
    > 与git reset的提交级版本一样，这更常用于HEAD而不是任意提交。
    > 运行`git reset HEAD foo.py`将取消暂存foo.py

  - Git检出文件
    > 检出文件类似于使用git reset和文件路径，除了它更新`工作区`而不是`暂存区`。(不过我试着是同时更新了`工作区`和`暂存区`)
    ```
    git checkout HEAD~2 foo.py
    ```

    > 与git reset一样，这通常与HEAD一起用作提交引用。
    > 例如，git checkout HEAD foo.py具有丢弃对foo.py的未暂存更改的效果。


  [参考链接](https://www.atlassian.com/git/tutorials/resetting-checking-out-and-reverting)

##### 合并

* Git合并特定commits 到另一个分支

  - 合并某个分支上的单个commit

    先用git log 查看你想合并的commit id，然后检出到你要执行合并操作的分支，用git cherry-pick合并

    ```shell
    $ git cherry-pick 62ecb3
    ```
  
  - 合并某个分支上的一系列commits

    首先需要基于feature创建一个新的分支，并指明新分支的最后一个commit：`git checkout -b newbranch 62ecb3`。
    然后，rebase这个新分支的commit到master（--ontomaster）。76cada^ 指明你想从哪个特定的commit开始。
    ```shell
    $ git checkout -b newbranch 62ecb3
    $ git rebase --onto master 76cada^
    ```

  > 注意：以上两种操作都是变基操作，不要在已公开的提交(已发布到远程分支的提交)上使用此操作。
  

##### 定位错误

  `git bisect`:利用二分法定位引入bug的分支。

  1. git bisect start <bad-SHA> <good-SHA>
  2. git检出中间分支，执行测试。如果没问题，执行`git bisect good`。否则执行`git bisect bad`。
  3. 循环步骤2，利用二分法，最终定位引入bug的分支。
  4. 退出bisect，`git bisect reset`。
  


