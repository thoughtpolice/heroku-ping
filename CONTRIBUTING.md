# Contributing

## Commits

Rules for contribution:

  * 80-character column maximum.
  * The first line of a commit message should be 73 columns max.
  * Try to make commits self contained. One thing at a time.
    If it's a branch, squash the commits together to make one.
  * Always run tests. If benchmarks regress, give OS information,
    and we'll discuss.
  * Always reference the issue you're working on in the bug tracker
    in your commit message, and if it fixes the issue, close it.

You can use GitHub pull requests OR just email me patches directly
(see `git format-patch --help`,) whatever you are more comfortable with.

For multi-commit requests, I will often squash them into the smallest
possible logical changes and commit with author attribution.

### Notes on sign-offs and attributions, etc.

When you commit, **please use -s to add a Signed-off-by line**. I manage
the `Signed-off-by` line much like Git itself: by adding it, you make clear
that the contributed code abides by the source code license. I'm pretty
much always going to want you to do this.

I normally merge commits manually and give the original author attribution
via `git commit --author`. I also sign-off on it, and add an `Acked-by` field
which basically states "this commit is not totally ludicrous."

Other fields may be added in the same vein for attribution or other purposes
(`Suggested-by`, `Reviewed-by`, etc.)

## Hacker notes

N/A.
