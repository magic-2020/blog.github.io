hexo clean
cp -r source/_posts/blog.github.io/images/*   source/images/

git checkout dev

git add .
git commit -m “修改内容提交到分支”
git pull --rebase origin dev
git push -u origin dev

git checkout github_blog
git pull --rebase origin github_blog

git merge dev
git status
git push -u origin github_blog
#git add -A
#git commit -m '写文章的blog全部备份'
#git pull --rebase github_blog github_blog
#git push -u github_blog github_blog

hexo g -d