#lang br
(require jsonic/parser jsonic/tokenizer brag/support)

(parse-to-datum (apply-tokenizer-maker make-tokenizer #<<DEREK
"foo"
// comment
@$ 42 $@
{ "bitch : @$ 'lyana $@ ,
  "ON HOL' ON" : "yeah" }
DEREK
))