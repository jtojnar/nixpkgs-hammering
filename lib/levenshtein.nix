{ lib
}:

/*
  Created by infinisil for https://github.com/NixOS/nixpkgs/pull/79877
  SPDX-License-Identifier: MIT
*/

let
  inherit (lib) stringLength substring;
in

rec {
  /* Computes the Levenshtein distance between two strings.
     Complexity O(n*m) where n and m are the lengths of the strings.
     Algorithm adjusted from https://stackoverflow.com/a/9750974/6605742
     Type: levenshtein :: string -> string -> int
     Example:
       levenshtein "foo" "foo"
       => 0
       levenshtein "book" "hook"
       => 1
       levenshtein "hello" "Heyo"
       => 3
  */
  levenshtein = a: b: let
    # Two dimensional array with dimensions (stringLength a + 1, stringLength b + 1)
    arr = lib.genList (i:
      lib.genList (j:
        dist i j
      ) (stringLength b + 1)
    ) (stringLength a + 1);
    d = x: y: lib.elemAt (lib.elemAt arr x) y;
    dist = i: j:
      let c = if substring (i - 1) 1 a == substring (j - 1) 1 b
        then 0 else 1;
      in
      if j == 0 then i
      else if i == 0 then j
      else lib.min
        ( lib.min (d (i - 1) j + 1) (d i (j - 1) + 1))
        ( d (i - 1) (j - 1) + c );
  in d (stringLength a) (stringLength b);

  /* Returns the length of the prefix common to both strings.
  */
  commonPrefixLength = a: b:
    let
      m = lib.min (stringLength a) (stringLength b);
      go = i: if i >= m then m else if substring i 1 a == substring i 1 b then go (i + 1) else i;
    in go 0;

  /* Returns the length of the suffix common to both strings.
  */
  commonSuffixLength = a: b:
    let
      m = lib.min (stringLength a) (stringLength b);
      go = i: if i >= m then m else if substring (stringLength a - i - 1) 1 a == substring (stringLength b - i - 1) 1 b then go (i + 1) else i;
    in go 0;

  /* Returns whether the levenshtein distance between two strings is at most some value
     Complexity is O(min(n,m)) for k <= 2 and O(n*m) otherwise
     Type: levenshteinAtMost :: int -> string -> string -> bool
     Example:
       levenshteinAtMost 0 "foo" "foo"
       => true
       levenshteinAtMost 1 "foo" "boa"
       => false
       levenshteinAtMost 2 "foo" "boa"
       => true
       levenshteinAtMost 2 "This is a sentence" "this is a sentense."
       => false
       levenshteinAtMost 3 "This is a sentence" "this is a sentense."
       => true
  */
  levenshteinAtMost = let
    infixDifferAtMost1 = x: y: stringLength x <= 1 && stringLength y <= 1;

    # This function takes two strings stripped by their common pre and suffix,
    # and returns whether they differ by at most two by Levenshtein distance.
    # Because of this stripping, if they do indeed differ by at most two edits,
    # we know that those edits were (if at all) done at the start or the end,
    # while the middle has to have stayed the same. This fact is used in the
    # implementation.
    infixDifferAtMost2 = x: y:
      let
        xlen = stringLength x;
        ylen = stringLength y;
        # This function is only called with |x| >= |y| and |x| - |y| <= 2, so
        # diff is one of 0, 1 or 2
        diff = xlen - ylen;

        # Infix of x and y, stripped by the left and right most character
        xinfix = substring 1 (xlen - 2) x;
        yinfix = substring 1 (ylen - 2) y;

        # x and y but a character deleted at the left or right
        xdelr = substring 0 (xlen - 1) x;
        xdell = substring 1 (xlen - 1) x;
        ydelr = substring 0 (ylen - 1) y;
        ydell = substring 1 (ylen - 1) y;
      in
        # A length difference of 2 can only be gotten with 2 delete edits,
        # which have to have happened at the start and end of x
        # Example: "abcdef" -> "bcde"
        if diff == 2 then xinfix == y
        # A length difference of 1 can only be gotten with a deletion on the
        # right and a replacement on the left or vice versa.
        # Example: "abcdef" -> "bcdez" or "zbcde"
        else if diff == 1 then xinfix == ydelr || xinfix == ydell
        # No length difference can either happen through replacements on both
        # sides, or a deletion on the left and an insertion on the right or
        # vice versa
        # Example: "abcdef" -> "zbcdez" or "bcdefz" or "zabcde"
        else xinfix == yinfix || xdelr == ydell || xdell == ydelr;

    in k: if k <= 0 then a: b: a == b else
      let f = a: b:
        let
          alen = stringLength a;
          blen = stringLength b;
          prelen = commonPrefixLength a b;
          suflen = commonSuffixLength a b;
          presuflen = prelen + suflen;
          ainfix = substring prelen (alen - presuflen) a;
          binfix = substring prelen (blen - presuflen) b;
        in
        # Make a be the bigger string
        if alen < blen then f b a
        # If a has over k more characters than b, even with k deletes on a, b can't be reached
        else if alen - blen > k then false
        else if k == 1 then infixDifferAtMost1 ainfix binfix
        else if k == 2 then infixDifferAtMost2 ainfix binfix
        else levenshtein ainfix binfix <= k;
      in f;
}
