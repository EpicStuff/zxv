## A bunch (currently only one) of usefull functions

proc ssplit(str: string, specials = ["\\*", "\"\"\"", "'''", "#[", "]#", "\\'"]): seq[string] =
  ## split a string into a list of individual letters as strings
  ## and string segment found in special will be concidered as a single "letter"
  ## default specials are ''', """, "\"", #[, ]#, \'
  var line: seq[string]
  var skip = 0
  # for each char in string
  for index, char in pairs(str):
    block a:
      #debugEcho index, "st char, ", char, ", skip: ", skip
      if skip > 0:
        skip -= 1
        continue
        # compare each char to each special
      for special in specials:
        block b:
          #debugEcho "\tchecking: \'", special, "\'"
          try:
            # take the first char in special
            for num, spe in special:
              #debugEcho "\t\tmatching: ", spe
              # if special is a star, auto match
              if spe == '*':
                continue
              # if they dont match, move on to the next special
              if spe != str[index + num]:
                break b
            # if match
            #debugEcho "\tmatch"
            var len = special.len - 1
            line.add(str[index..index+len])
            skip += len
            break a
          except IndexDefect:
            discard
      #debugEcho "\tno match"
      line.add($char)
  return line