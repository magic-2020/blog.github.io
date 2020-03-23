hexo clean
git add -A
git commit -m '写文章的blog全部备份'
git push -u github_blog github_blog
git pull --rebase github_blog github_blog
hexo s -d