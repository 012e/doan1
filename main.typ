#set text(font: "Times New Roman", size: 13pt)
#set heading(numbering: "1.")
#set page("a4")
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages, zebra-fill: none, stroke: black + 1pt)
#set text(lang: "vi")
#set par(justify: true)

#show raw: set text(font: "IosevkaNerdFont", size: 10pt) 

#set table(
  fill: (x, y) =>
    if y == 0 { luma(240) }
    else if x == 0{ luma(250) },
)

#show table.cell.where(y: 0): strong

#set table(align: left + horizon)

#let version = raw(read("version.txt"))
#let uit-color = rgb("#4a63b8")

#page(margin: 1cm)[
  #rect(width: 100%, height: 100%, stroke: 3pt + uit-color)[
    #pad(rest: 10pt)[
      #align(center)[
        #text(size: 17pt)[*ĐẠI HỌC QUỐC GIA THÀNH PHỐ HỒ CHÍ MINH*] \
        #text[*TRƯỜNG ĐẠI HỌC CÔNG NGHỆ THÔNG TIN*] \
        #text[*KHOA CÔNG NGHỆ PHẦN MỀM*] \ 
        #text(fill: white, size: 20pt)[SECRET: version #version]
        #v(50pt)
        #image("images/logo-uit.svg", width: 200pt)
      ]
      #align(horizon + center)[
        #text(size: 26pt)[*Đồ án 2*] \
        #v(3pt)
        #text(size: 30pt)[*Tìm hiểu về .NET Core 8*] \
        #v(20pt)

        #text[Giảng viên hướng dẫn] \
        #text[*Ths. Nguyễn Công Hoan*] \

        #v(10pt)

        #text[Sinh viên thực hiện] \
        #text[*Phạm Nhật Huy #sym.dash.en 23520643*] \
      ]
      #align(bottom + center)[
        #text(size: 13pt)[
          #text[Thành phố Hồ Chí Minh], ngày
          #datetime.today().display("[day]/[month]/[year]")
        ]
      ]
    ]
  ]

]



#pagebreak()


#include "thank.typ"

#pagebreak()

#[
  #align(center)[
      #text(20pt, weight: "bold")[MỤC LỤC]
      #v(20pt)
  ]
  #show outline.entry.where(level: 1): it => {
    set text(size: 14pt, weight: "bold")
    set block(above: 1em)
    [#text(size: 14pt)[
      #link(it.element.location())[Chương #it.prefix() #it.inner()]]
    ]
  }

  #outline(
    title: [],
    indent: 1.5em,
  )
]

#pagebreak()

#align(center)[
    #text(20pt, weight: "bold")[PHỤ LỤC HÌNH ẢNH]
    #v(20pt)
]
#outline(
  title: [],
  target: figure.where(kind: image),
)

#pagebreak()

#set page(numbering: "1")

#show heading.where(level: 1): it => {
  [Chương #counter(heading).at(here()).at(0). ] + it.body
}

#include "problem-statement.typ"
#pagebreak()

#include "introduction.typ"
#include "load-balancer.typ"
#include "caching.typ"
#include "microservices.typ"
#include "service-discovery.typ"
#include "distributed-transaction.typ"
#include "consensus.typ"
#include "deployment.typ"
#include "dotnet.typ"
#include "best-practices.typ"

#pagebreak()
#align(center)[
    #text(20pt, weight: "bold")[TÀI LIỆU THAM KHẢO]
    #v(20pt)
]

#bibliography("references.bib", title: none, full: true)

