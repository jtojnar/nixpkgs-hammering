Each patch in nixpkgs applied to the upstream source should be documented. Out-of-tree patches, fetched using `fetchpatch`, are preferred.

In each patch comment, please explain the purpose of the patch and link to the relevant upstream issue if possible. If the patch has been merged upstream but is not yet part of the released version, please note the version number or date in the comment such that a future maintainer updating the nix expression will know whether the patch has been incorporated upstream and can thus be removed from nixpkgs.

Furthermore, please use a *stable* URL for the patch. Rather than, for example, linking to a GitHub pull request of the form `https://github.com/owner/repo/pull/pr_number.patch`, which would change every time a commit is added or the PR is force-pushed, link to a specific commit patch in the form `https://github.com/owner/repo/commit/sha.patch`.

Here are two good examples of patch comments:

```nix
mkDerivation {
  …

  patches = [
    # Ensure RStudio compiles against R 4.0.0.
    # Should be removed next 1.2.X RStudio update or possibly 1.3.X.
    (fetchpatch {
      url = "https://github.com/rstudio/rstudio/commit/3fb2397c2f208bb8ace0bbaf269481ccb96b5b20.patch";
      sha256 = "0qpgjy6aash0fc0xbns42cwpj3nsw49nkbzwyq8az01xwg81g0f3";
    })
  ];
}
```

```nix
mkDerivation {
  …

  patches = [
    # Allow building with bison 3.7
    # PR at https://github.com/GoldenCheetah/GoldenCheetah/pull/3590
    (fetchpatch {
      url = "https://github.com/GoldenCheetah/GoldenCheetah/commit/e1f42f8b3340eb4695ad73be764332e75b7bce90.patch";
      sha256 = "1h0y9vfji5jngqcpzxna5nnawxs77i1lrj44w8a72j0ah0sznivb";
    })
  ];
}
```
