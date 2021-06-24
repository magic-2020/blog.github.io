git checkout dev
hexo clean
cp -r source/_posts/blog.github.io/images/*   source/images/
git add .
git commit -m “修改内容提交到分支dev”
git pull --rebase origin dev
git push -u origin dev

git checkout github_blog
git pull --rebase origin github_blog
git merge dev
git status

hexo clean
cp -r source/_posts/blog.github.io/images/*   source/images/
git add .
git commit -m “修改内容提交到分支github_blog”
git pull --rebase origin github_blog
git push -u origin github_blog

hexo g -d