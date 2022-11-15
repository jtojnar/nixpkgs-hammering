The `lib.licenses.gpl3` attribute refers to GPL 3.0 only. Unfortunately, it is not clear from the attribute name so people often use that without realizing `lib.licenses.gpl3Plus` might be more precise.

To avoid this confusion, the unqualified GNU licenses were deprecated, in line with the [GNU recommendations](https://gnu.org/licenses/identify-licenses-clearly.html).

## What to do?

Replace the deprecated unqualified in `meta.license` as follows:

- `agpl3` by either `agpl3Plus` or `agpl3Only`
- `gpl2` by either `gpl2Plus` or `gpl2Only`
- `gpl3` by either `gpl3Plus` or `gpl3Only`
- `lgpl2` by either `lgpl2Plus` or `lgpl2Only`
- `lgpl21` by either `lgpl21Plus` or `lgpl21Only`
- `lgpl3` by either `lgpl3Plus` or `lgpl3Only`

## How to determine license

Projects might mention license terms in the `README` file or on their homepage.

If that is not the case, check few source files. They might contain a blurb in the comment at the top of a file, similar to the following:

> This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, **or (at your option) any later version**.

You can also try to grep (or search on GitHub) the repository for `license`.

**Do not** rely on the contents of `COPYING` file or the license shown by the GitHub/GitLab interface (which is determined from the `COPYING` file) – the file only contains the text of GNU ?GPL itself, as mandated by the license. The extra terms allowing to use later versions of the license would be stored in the source code/documentation.

If no statement about license terms is found, you should ask the project maintainers to clarify.

## See also

- [Pull request that deprecated the unqualified license](https://github.com/NixOS/nixpkgs/pull/92348)
- [Relevant Discourse thread](https://discourse.nixos.org/t/lib-licenses-gpl3-co-are-now-deprecated/8206)
