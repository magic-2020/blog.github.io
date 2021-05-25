git checkout dev

git add .
git commit -m “修改内容提交到分支”

cp -r source/_posts/blog.github.io/images/*   source/images/
hexo clean
hexo s -d