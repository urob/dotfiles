#!/usr/bin/python3
"""
Colorscheme brewer for LyX

Usage: ./make_colorscheme.py palette
Output: palette.out
"""

# get color palette from commmand line argument
import sys
colors = str(sys.argv[1])

# import color definitions
palette = None
exec(open("colors/" + colors + ".def").read())
# palette = __import__(colors).palette

palette["note_bg"]    = palette["black"]  # note, comment, grayedout content background
palette["note_fg"]    = palette["green"]  # note, comment, grayedout label foreground
palette["formatting"] = palette["white"]  # spaces, newpages, etc

# map the palette to LyX colors
colorscheme = {
    "added_space":               palette["formatting"],   # FORMATTING: spaces
    "addedtext":                 palette["yellow"],       # ???
    "appendix":                  palette["formatting"],   # FORMATTING: begin appendix
    "background":                palette["background"],   # BACKGROUND: main canvas
    "bottomarea":                palette["background"],   # only relevant if scroll below end of document is activated in settings
    "branchlabel":               palette["yellow"],       # branch label
    "buttonbg":                  palette["background"],   # less distracting button
    "buttonframe":               palette["brightblack"],  # buttonframe
    "buttonhoverbg":             palette["brightblack"],  # button background when hovered
    "changebar":                 palette["blue"],         # track changes: changed-lines marker in left margin
    "changedtextauthor1":        palette["blue"],         # track changes: N-th author's changed text
    "changedtextauthor2":        palette["magenta"],      #   - " -
    "changedtextauthor3":        palette["cyan"],         #   - " -
    "changedtextauthor4":        palette["green"],        #   - " -
    "changedtextauthor5":        palette["yellow"],       #   - " -
    "collapsible":               palette["yellow"],       # label-fg for non-note collapsiles (floats, etc)
    "collapsibleframe":          palette["brightblack"],  # frame for collapsibles content (notes, floats, etc)
    "command":                   palette["blue"],         # label-fg for cites, refs, labels, etc
    "commandbg":                 palette["background"],   # command insets background (eg, index list)
    "commandframe":              palette["brightblack"],  # command inset frame (eg, index list)
    "comment":                   palette["note_fg"],      # NOTE_FG: comment-note button label-fg
    "commentbg":                 palette["note_bg"],      # NOTE_BG: comment-note
    "cursor":                    palette["cursorcolor"],  # CURSOR_COLOR
    "deletedtext":               palette["red"],          # deleted text
    "deletedtextmodifier":       palette["background"],   # track changes: deleted text (blended with author color)
    "depthbar":                  palette["white"],        # margin lines for nested environments
    "eolmarker":                 palette["formatting"],   # FORMATTING: linebreak
    "error":                     palette["red"],          # latex error
    "footlabel":                 palette["green"],        # footnote label-fg
    "foreground":                palette["foreground"],   # FOREGROUND: text
    "graphicsbg":                palette["background"],   # ???
    "greyedout":                 palette["note_fg"],      # NOTE_FG: grayed-out-note button label-fg
    "greyedoutbg":               palette["note_bg"],      # NOTE_BG: greyed-out-note
    "indexlabel":                palette["green"],        # label-color for index entry
    "inlinecompletion":          palette["foreground"],   # FOREGROUND: unambigous completion part, cf nouniqueinlinecompletion
    "insetbg":                   palette["brightblack"],  # ???
    "insetframe":                palette["yellow"],       # ???
    "language":                  palette["magenta"],      # color for marking foreign language words
    "latex":                     palette["cyan"],         # latex + beamer (frame/section)
    "listingsbg":                palette["brightblack"],  # program code
    "marginlabel":               palette["magenta"],      # margin-note label
    "math":                      palette["foreground"],   # FOREGROUND: math
    "mathbg":                    palette["background"],   # BACKGROUND: math
    "mathcorners":               palette["background"],   # hide corners
    "mathframe":                 palette["cyan"],         # corners when hovering
    "mathline":                  palette["cyan"],         # empty placeholders (arrays, etc)
    "mathmacrobg":               palette["background"],   # math-macro config
    "mathmacroblend":            palette["foreground"],   #   - " -
    "mathmacroframe":            palette["brightblack"],  #   - " -
    "mathmacrohoverbg":          palette["brightblack"],  #   - " -
    "mathmacronewarg":           palette["foreground"],   #   - " -
    "mathmacrooldarg":           palette["white"],        #   - " -
    "newpage":                   palette["formatting"],   # FORMATTING: newpage
    "nonuniqueinlinecompletion": palette["white"],        # grayed out text when completing with TAB
    "note":                      palette["note_fg"],      # NOTE_FG: lyx-note button label-fg
    "notebg":                    palette["note_bg"],      # NOTE_BG: lyx-note
    "pagebreak":                 palette["formatting"],   # FORMATTING: pagebreak
    "paragraphmarker":           palette["brightblack"],  # paragraph markers (¶)
    "phantomtext":               palette["white"],        # text color for phantom insets
    "preview":                   palette["foreground"],   # FOREGROUND: mathpreview
    "previewframe":              palette["yellow"],       # preview frame (for ERT)
    "regexpframe":               palette["green"],        # color for regexp frame
    "scroll":                    palette["red"],          # scroll indicator
    "selection":                 palette["yellow"],       # selection background
    "selectiontext":             palette["background"],   # selection foreground
    "shaded":                    palette["brightblack"],  # shaded box background
    "special":                   palette["yellow"],       # special chars text color
    "tabularline":               palette["white"],        # tabular lines
    "tabularonoffline":          palette["white"],        # ???
    "urllabel":                  palette["white"],        # url-label (hidden when collapsed)
    "urltext":                   palette["magenta"],      # url
    "blue":                      palette["blue"],         # for beamer layout
    "green":                     palette["green"],        # for beamer layout
    "red":                       palette["red"],          # for beamer layout
}

# export the colorscheme
file = "out/" + colors + ".out"
with open(file, "w") as o:
    o.write("# " + colors + " colorscheme for LyX\n")

with open(file, "a") as o:
    for color, value in colorscheme.items():
        o.write('\set_color "' + color + '" "' + value + '"\n')

