# Publishing to GitHub

Use this checklist before the first public push.

## Before pushing

- verify that no model weights or tokenizer binaries are staged
- verify that `node_modules/`, `www/`, `Pods/`, and `vendor/` stay ignored
- make sure the README reflects the current project status honestly
- confirm that the MIT license is the one you want for the source code

## First push

```bash
cd <repo-root>
git add .
git commit -m "chore: initial open source release"
git remote add origin git@github.com:<your-user>/<your-repo>.git
git push -u origin main
```

## Recommended GitHub settings

- enable Issues
- enable Discussions if you want community design feedback
- enable Security Advisories
- add repository topics such as `ionic`, `capacitor`, `ios`, `pytorch-mobile`, `llm`
- add a short repository description

## Good first follow-up tasks

- create a first public issue with the current roadmap
- create a pinned issue for iOS setup pain points
- collect device test results from contributors

