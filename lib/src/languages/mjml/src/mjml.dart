part of '../mjml.dart';

const List<String> mjmlTags = [
  "mjml",
  "mj-body",
  "mj-head",
  "mj-title",
  "mj-style",
  "mj-include",
  "mj-preview",
  "mj-section",
  "mj-column",
  "mj-text",
  "mj-image",
  "mj-button",
  "mj-divider",
  "mj-spacer",
  "mj-table",
  "mj-hero",
  "mj-navbar",
  "mj-navbar-link",
  "mj-wrapper",
  "mj-accordion",
  "mj-accordion-element",
  "mj-accordion-title",
  "mj-accordion-text",
  "mj-carousel",
  "mj-carousel-image",
  "mj-carousel-text",
  "mj-social",
  "mj-social-element",
  "mj-social-icon",
  "mj-social-text",
  "mj-social-link",
  "mj-style-inline",
  "mj-style-external",
  "mj-font",
  "mj-class",
  "mj-all",
];

final backlashScape = Mode(begin: "\\\\[\\s\\S]", relevance: 0);

final phrasalWordsMode = Mode(
    begin:
        "\\b(a|an|the|are|I'm|isn't|don't|doesn't|won't|but|just|should|pretty|simply|enough|gonna|going|wtf|so|such|will|you|your|they|like|more)\\b");

final mjml = Mode(
    refs: {
      '~contains~6~contains~0': Mode(endsWithParent: true, illegal: "<", relevance: 0, contains: [
        Mode(className: "attr", begin: "[A-Za-z0-9\\._:-]+", relevance: 0),
        Mode(begin: "=\\s*", relevance: 0, contains: [
          Mode(className: "string", endsParent: true, variants: [
            Mode(begin: "\"", end: "\"", contains: [Mode(ref: '~contains~3')]),
            Mode(begin: "'", end: "'", contains: [Mode(ref: '~contains~3')]),
            Mode(begin: "[^\\s\"'=<>`]+")
          ])
        ])
      ]),
      '~contains~3': Mode(className: "symbol", begin: "&[a-z]+;|&#[0-9]+;|&#x[a-f0-9]+;"),
      '~contains~0~contains~3':
          Mode(begin: "\\(", contains: [Mode(ref: '~contains~0~contains~0~contains~0')], end: "\\)"),
      '~contains~0~contains~2':
          Mode(className: "meta-string", begin: "'", end: "'", illegal: "\\n", contains: [backlashScape]),
      '~contains~0~contains~1':
          Mode(className: "meta-string", begin: "\"", end: "\"", illegal: "\\n", contains: [backlashScape]),
      '~contains~0~contains~0~contains~0':
          Mode(className: "meta-keyword", begin: "#?[a-z_][a-z1-9_-]+", illegal: "\\n"),
      '~contains~0~contains~0': Mode(begin: "\\s", contains: [Mode(ref: '~contains~0~contains~0~contains~0')]),
    },
    aliases: ["html", "xhtml", "rss", "atom", "xjb", "xsd", "xsl", "plist", "wsf", "svg"],
    case_insensitive: true,
    contains: [
      Mode(className: "meta", begin: "<![a-z]", end: ">", relevance: 10, contains: [
        Mode(ref: '~contains~0~contains~0'),
        Mode(ref: '~contains~0~contains~1'),
        Mode(ref: '~contains~0~contains~2'),
        Mode(ref: '~contains~0~contains~3'),
        Mode(begin: "\\[", end: "\\]", contains: [
          Mode(className: "meta", begin: "<![a-z]", end: ">", contains: [
            Mode(ref: '~contains~0~contains~0'),
            Mode(ref: '~contains~0~contains~3'),
            Mode(ref: '~contains~0~contains~1'),
            Mode(ref: '~contains~0~contains~2')
          ])
        ])
      ]),
      Mode(
          className: "comment",
          begin: "<!--",
          end: "-->",
          contains: [phrasalWordsMode, Mode(className: "doctag", begin: "(?:TODO|FIXME|NOTE|BUG|XXX):", relevance: 0)],
          relevance: 10),
      Mode(begin: "<\\!\\[CDATA\\[", end: "\\]\\]>", relevance: 10),
      Mode(ref: '~contains~3'),
      Mode(className: "meta", begin: "<\\?xml", end: "\\?>", relevance: 10),
      // Mode(begin: "<\\?(php)?", end: "\\?>", subLanguage: [
      //   "php"
      // ], contains: [
      //   Mode(begin: "/\\*", end: "\\*/", skip: true),
      //   Mode(begin: "b\"", end: "\"", skip: true),
      //   Mode(begin: "b'", end: "'", skip: true),
      //   Mode(className: null, begin: "'", end: "'", illegal: null, contains: null, skip: true),
      //   Mode(className: null, begin: "\"", end: "\"", illegal: null, contains: null, skip: true)
      // ]),
      // Mode(
      //     className: "tag",
      //     begin: "<style(?=\\s|>)",
      //     end: ">",
      //     keywords: {"name": "style"},
      //     contains: [Mode(ref: '~contains~6~contains~0')],
      //     starts: Mode(end: "</style>", returnEnd: true, subLanguage: ["css", "xml"])),
      // Mode(
      //     className: "tag",
      //     begin: "<script(?=\\s|>)",
      //     end: ">",
      //     keywords: {"name": "script"},
      //     contains: [Mode(ref: '~contains~6~contains~0')],
      //     starts: Mode(
      //         end: "</script>", returnEnd: true, subLanguage: ["actionscript", "javascript", "handlebars", "xml"])),
      Mode(
          className: "tag",
          begin: "</?",
          end: "/?>",
          contains: [Mode(className: "name", begin: "[^\\/><\\s]+", relevance: 0), Mode(ref: '~contains~6~contains~0')])
    ]);
