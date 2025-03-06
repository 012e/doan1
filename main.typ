#set text(font: "Times New Roman", size: 15pt)
#set heading(numbering: "1.")
#set page("a4")
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages)

#let uit-color = rgb("#4a63b8")

#page(margin: 1cm)[
#rect(width: 100%, height: 100%, stroke: uit-color,)[
#align(horizon + center)[
  #text([BÁO CÁO THIẾT KẾ VÀ XÂY DỰNG HỆ THỐNG], size: 30pt)
]


#align(horizon + left)[

  #text(size: 24pt, [Offensive Security Exploitation \ Expert Exam Report])



  OSEE Exam Report



  student\@youraddress.com, OSID: XXXX

]
]

]



#pagebreak()
#set page(numbering: "1")
#outline(title: [
  #text([Mục lục], size: 30pt)
  #v(10pt)
])
#pagebreak()

#show heading.where(level: 1): it => {    
        [Chương #counter(heading).at(here()).at(0). ] + it.body
}



= Tổng quan về thiết kế hệ thống

==  Thiết kế các hệ thống nhỏ và trong các hệ thống lớn

== Các nguyên lý thiết kế hệ thống

=== Scalability

=== Availability

=== Consistency

==== Fault tolerance

==== Byzantine fault

= Load balancer

== Giới thiệu

== Phân loại

=== Hardware & Software

=== Tầng xử lý

== Thuật toán

== Pattern

== Tăng availability của hệ thống

= Caching

== Tổng quan về caching

== Các pattern trong caching

=== Local cache

=== Distributed cache

=== Reverse proxy cache

=== Sidecar cache

=== Reverses proxy sidecar cache

== Làm trống cache (Cache eviction)

== Các pattern truy cập trong caching

=== Cache-aside

=== Read-through

=== Write-through

=== Write-back (Write-behind)

= Microservices

== Tổng quan về microservices

== Phương thức giao tiếp giữa các microservices

== Khuyết điểm của microservices

= Service discovery & API gateway

== Phân loại service discovery

== Phân loại hình thức register

== Sử dụng service

=== Direct

=== Composite UI

=== API gateway

== Envoy

=== Giới thiệu

=== Kiến trúc

= Distributed transactions

== Tổng quan về transactions

== Two-phase commit (2PC)

== Three-phase commit (3PC)

== Saga

== So sánh Two-phase commit/Three-phase commit và Saga

= Consensus

== Vấn đề consensus

== Thuật toán Raft

=== Khái quát về Raft

=== Bầu cử leader

=== Hoạt động bình thường của thuật toán

=== Ưu điểm và nhược điểm của Raft

==== Ưu điểm

==== Nhược điểm

= Deployment

== Deploy patterns

=== Multiple instances per host

=== Single instance per host

== Docker

=== Kubernetes và Helm

=== Kubernetes

=== Helm

== Consul

== Grafana + Prometheus

=== Grafana

=== Prometheus

= Xây dựng hệ thống với .NET Core

