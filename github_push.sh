hexo clean
cp -r source/_posts/blog.github.io/images/*   source/images/
git add -A
git commit -m '写文章的blog全部备份'
git pull --rebase github_blog github_blog
git push -u github_blog github_blog
hexo g -d