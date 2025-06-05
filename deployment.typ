= Deployment
<deployment>
== Deploy patterns
<deploy-patterns>
=== Multiple instances per host
<multiple-instances-per-host>
#strong[Multiple Instances per Host] là mô hình triển khai trong đó
#strong[nhiều phiên bản của một ứng dụng hoặc dịch vụ] chạy trên cùng
một máy chủ vật lý hoặc máy ảo. Điều này giúp #strong[tận dụng tối đa
tài nguyên];, #strong[giảm chi phí hạ tầng] và #strong[tăng hiệu quả sử
dụng máy chủ];. Tuy nhiên, nó cũng đòi hỏi #strong[quản lý tài nguyên
chặt chẽ] để tránh xung đột và quá tải hệ thống.

#image("images/2025-03-07-22-24-02.png")

- #strong[Ưu điểm];:
  - Tối ưu hóa việc sử dụng tài nguyên phần cứng
  - Giảm chi phí hạ tầng
  - Dễ dàng mở rộng theo chiều ngang với ít máy chủ hơn
- #strong[Nhược điểm];:
  - Khả năng cạnh tranh tài nguyên giữa các instance
  - Khó khăn trong việc cô lập lỗi và đảm bảo an toàn
  - Vấn đề về quản lý phụ thuộc nếu các ứng dụng yêu cầu các phiên bản
    thư viện khác nhau
- #strong[Trường hợp áp dụng];:
  - Các ứng dụng có mức tiêu thụ tài nguyên thấp
  - Môi trường phát triển và kiểm thử
  - Hệ thống có ngân sách hạn chế

=== Single instance per host
<single-instance-per-host>
#strong[Single Instance per Host] là mô hình triển khai trong đó
#strong[mỗi máy chủ chỉ chạy một phiên bản của ứng dụng hoặc dịch vụ];.
Điều này giúp #strong[cách ly tài nguyên];, #strong[cải thiện hiệu suất
và độ ổn định];, đồng thời #strong[giảm rủi ro xung đột] giữa các ứng
dụng. Tuy nhiên, mô hình này có thể #strong[tốn nhiều tài nguyên hơn] so
với chạy nhiều phiên bản trên cùng một máy chủ.

- #strong[Ưu điểm];:
  - Cô lập tài nguyên và quy trình xử lý
  - Tăng tính bảo mật và ổn định
  - Đơn giản hóa việc quản lý vòng đời ứng dụng
  - Dễ dàng mở rộng theo chiều dọc (vertical scaling)
- #strong[Nhược điểm];:
  - Chi phí hạ tầng cao hơn
  - Lãng phí tài nguyên nếu ứng dụng không sử dụng hết công suất máy chủ
- #strong[Trường hợp áp dụng];:
  - Các ứng dụng đòi hỏi hiệu suất cao
  - Dịch vụ cần độ tin cậy và khả năng dự đoán cao
  - Hệ thống sản xuất quan trọng

== Containerization
<containerization>
=== Docker
<docker>

#strong[Docker] là một nền tảng #strong[ảo hóa cấp độ hệ điều hành] giúp
đóng gói ứng dụng và các phụ thuộc của nó vào một #strong[container];.
Container này có thể chạy nhất quán trên nhiều môi trường khác nhau, từ
máy tính cá nhân đến máy chủ và đám mây. Docker giúp #strong[tối ưu hóa
việc triển khai, tăng tính di động, giảm xung đột môi trường và cải
thiện hiệu suất] trong việc phát triển và vận hành phần mềm.

#image("images/2025-03-07-22-22-49.png")

- #strong[Thành phần chính];:
  - #strong[Docker Engine];: Runtime để tạo và quản lý container
  - #strong[Docker Image];: Template chỉ đọc chứa mã nguồn, thư viện,
    phụ thuộc và các file cần thiết
  - #strong[Dockerfile];: File kịch bản định nghĩa cách tạo image
  - #strong[Docker Registry];: Kho lưu trữ và chia sẻ image (Docker Hub,
    Amazon ECR, Google Container Registry)
  - #strong[Docker Compose];: Công cụ định nghĩa và chạy ứng dụng Docker
    đa container
- #strong[Ưu điểm];:
  - Tính nhất quán giữa các môi trường
  - Khả năng di động cao
  - Hiệu quả về tài nguyên hơn so với máy ảo
  - Cô lập ứng dụng và phụ thuộc
- #strong[Nhược điểm];:
  - Vấn đề về bảo mật nếu không được cấu hình đúng
  - Độ phức tạp trong quản lý mạng và lưu trữ dữ liệu dài hạn
  - Chi phí hiệu suất nhỏ so với ứng dụng chạy trực tiếp trên host
- #strong[Các lệnh Docker cơ bản];:
  ```bash
  docker build -t myapp:1.0 .            # Tạo image từ Dockerfile
  docker run -d -p 8080:80 myapp:1.0     # Chạy container
  docker ps                              # Liệt kê container đang chạy
  docker logs container_id               # Xem logs
  docker exec -it container_id bash      # Truy cập vào container
  ```

=== Podman
<podman>
#strong[Podman] là một công cụ quản lý container mã nguồn mở, tương tự
như Docker, nhưng không yêu cầu #strong[daemon] chạy nền. Nó hỗ trợ
#strong[chạy, xây dựng và quản lý container] theo chuẩn OCI (Open
Container Initiative). Podman có thể chạy container #strong[không cần
quyền root];, giúp #strong[tăng cường bảo mật];. Ngoài ra, nó có thể
thay thế Docker trong nhiều trường hợp mà không cần thay đổi quá nhiều
về workflow.

- #strong[Đặc điểm nổi bật];:
  - Kiến trúc không daemon (daemonless)
  - Mô hình bảo mật tốt hơn với khả năng chạy dưới quyền người dùng
    thông thường
  - Hỗ trợ pod (nhóm container) giống Kubernetes
  - Tương thích với Docker, sử dụng cùng định dạng image
- #strong[Ưu điểm];:
  - Bảo mật tốt hơn do không cần quyền root
  - Sử dụng ít tài nguyên hơn khi không có daemon chạy liên tục
  - Tích hợp tốt với systemd
  - Tương thích API với Docker giúp chuyển đổi dễ dàng
- #strong[Nhược điểm];:
  - Một số tính năng Docker chưa được hỗ trợ đầy đủ
  - Cộng đồng nhỏ hơn so với Docker
- #strong[Các lệnh Podman cơ bản];:
  ```bash
  podman build -t myapp:1.0 .            # Tạo image
  podman run -d -p 8080:80 myapp:1.0     # Chạy container
  podman ps                              # Liệt kê container
  podman pod create --name mypod         # Tạo pod
  podman generate kube mypod > pod.yaml  # Tạo file cấu hình Kubernetes
  ```

=== Kubernetes & Helm
<kubernetes--helm>
==== Kubernetes
<kubernetes>
#strong[Kubernetes] là một nền tảng #strong[orchestration] mã nguồn mở
dùng để #strong[tự động triển khai, mở rộng và quản lý] các ứng dụng
container. Nó giúp quản lý #strong[các container] trên một cụm máy chủ,
cung cấp các tính năng như #strong[cân bằng tải, tự động phục hồi,
scaling linh hoạt] và #strong[quản lý cấu hình];. Kubernetes cho phép
ứng dụng chạy ổn định, dễ dàng mở rộng và tối ưu hóa tài nguyên trong
môi trường #strong[cloud-native];.

#align(center)[
  #image("images/2025-03-07-22-29-48.png", width: 5cm)
]

- #strong[Kiến trúc];:
  - #strong[Control Plane];:
    - #strong[API Server];: Giao diện để tương tác với cluster
    - #strong[etcd];: Cơ sở dữ liệu phân tán lưu trữ cấu hình cluster
    - #strong[Scheduler];: Phân phối pods đến các nodes
    - #strong[Controller Manager];: Quản lý các controller như node
      controller, replication controller
  - #strong[Worker Nodes];:
    - #strong[Kubelet];: Đảm bảo containers chạy trong pod
    - #strong[Kube-proxy];: Duy trì network rules trên nodes
    - #strong[Container Runtime];: Docker, containerd, CRI-O
- #strong[Các thành phần cơ bản];:
  - #strong[Pod];: Đơn vị nhỏ nhất, chứa một hoặc nhiều container
  - #strong[Service];: Cung cấp network endpoint ổn định cho pods
  - #strong[Deployment];: Quản lý việc tạo và cập nhật pods
  - #strong[StatefulSet];: Quản lý các ứng dụng stateful
  - #strong[ConfigMap & Secret];: Quản lý cấu hình và thông tin nhạy cảm
  - #strong[Ingress];: Quản lý truy cập HTTP từ bên ngoài cluster
  - #strong[Namespace];: Phân chia tài nguyên cluster theo logic
- #strong[Ưu điểm];:
  - Tự động hóa cao: tự phát hiện lỗi, tự phục hồi, tự mở rộng
  - Quản lý declarative thông qua YAML
  - Hỗ trợ triển khai nhiều môi trường (on-premises, cloud)
  - Cộng đồng lớn và hệ sinh thái phong phú
- #strong[Nhược điểm];:
  - Đường cong học tập dốc
  - Phức tạp trong việc cài đặt và bảo trì
  - Tốn nhiều tài nguyên cho các cluster nhỏ
- #strong[Các công cụ quản lý];:
  - #strong[kubectl];: CLI chính thức để tương tác với clusters
  - #strong[k9s];: Terminal UI cho Kubernetes
  - #strong[Lens];: GUI desktop cho quản lý Kubernetes
  - #strong[Managed K8s];: EKS (AWS), GKE (Google), AKS (Azure)

==== Helm
<helm>
#strong[Helm] là một trình quản lý package dành cho #strong[Kubernetes];,
giúp tự động hóa việc #strong[triển khai, quản lý và cập nhật] ứng dụng
dưới dạng #strong[biểu đồ (Helm Charts)];. Nó cho phép định nghĩa, cài
đặt và quản lý các ứng dụng Kubernetes một cách #strong[dễ dàng, có thể
tái sử dụng và có thể cấu hình linh hoạt];. Helm giúp đơn giản hóa quá
trình triển khai ứng dụng phức tạp, hỗ trợ #strong[rollbacks,
versioning] và quản lý #strong[dependencies] trong Kubernetes.

#align(center)[
  #image("images/2025-03-07-22-27-44.png", width: 5cm)
]

- #strong[Thành phần chính];:
  - #strong[Chart];: Gói các tài nguyên Kubernetes liên quan
  - #strong[Repository];: Nơi lưu trữ và chia sẻ charts
  - #strong[Release];: Instance của chart chạy trong cluster
- #strong[Cấu trúc Chart];:
  ```
  mychart/
  ├── Chart.yaml         # Thông tin về chart
  ├── values.yaml        # Giá trị mặc định
  ├── templates/         # Các template Kubernetes
  │   ├── deployment.yaml
  │   ├── service.yaml
  │   └── _helpers.tpl
  └── charts/            # Chart phụ thuộc (nếu có)
  ```
- #strong[Ưu điểm];:
  - Đơn giản hóa việc triển khai ứng dụng phức tạp
  - Quản lý phiên bản và rollback dễ dàng
  - Tái sử dụng cấu hình qua các môi trường
  - Chia sẻ ứng dụng trong cộng đồng qua Helm Hub
- #strong[Nhược điểm];:
  - Thêm lớp trừu tượng có thể gây khó khăn khi gỡ lỗi
  - Cách tiếp cận template có thể tạo ra các cấu hình phức tạp
- #strong[Các lệnh Helm cơ bản];:
  ```bash
  helm create mychart               # Tạo chart mới
  helm install myrelease mychart    # Cài đặt chart
  helm upgrade myrelease mychart    # Nâng cấp release
  helm rollback myrelease 1         # Rollback về phiên bản 1
  helm uninstall myrelease          # Gỡ bỏ release
  helm repo add bitnami https://charts.bitnami.com/bitnami  # Thêm repository
  ```

== Infrastructure & Configuration Management
<infrastructure--configuration-management>
=== Infrastructure as Code (IaC)
<infrastructure-as-code-iac>
#strong[Infrastructure as Code (IaC)] là phương pháp quản lý và cung cấp
#strong[hạ tầng IT] bằng cách sử dụng #strong[các tập tin cấu hình hoặc
mã nguồn];, thay vì cấu hình thủ công. IaC giúp #strong[tự động hóa,
tăng tính nhất quán, giảm lỗi con người và cải thiện khả năng mở rộng];.
Các công cụ phổ biến như #strong[Terraform, Ansible, CloudFormation] cho
phép định nghĩa hạ tầng dưới dạng #strong[code];, giúp dễ dàng kiểm soát
phiên bản, tái sử dụng và triển khai trên nhiều môi trường.
- #strong[Công cụ phổ biến];:
  - #strong[Terraform];:
    - Công cụ mã nguồn mở, ngôn ngữ HCL
    - Hỗ trợ nhiều cloud provider (AWS, Azure, GCP)
    - Sử dụng state file để theo dõi tài nguyên
    - Tính mô-đun cao với Terraform modules

    ```hcl
    provider "aws" {
      region = "us-west-2"
    }

    resource "aws_instance" "example" {
      ami           = "ami-0c55b159cbfafe1f0"
      instance_type = "t2.micro"
      tags = {
        Name = "example-instance"
      }
    }
    ```
  - #strong[AWS CloudFormation];:
    - Dịch vụ riêng của AWS
    - Sử dụng JSON hoặc YAML
    - Tích hợp sâu với các dịch vụ AWS
    - Hỗ trợ drift detection
  - #strong[Azure Resource Manager (ARM)];:
    - Dịch vụ quản lý tài nguyên của Azure
    - Sử dụng JSON templates
    - Hỗ trợ Role-Based Access Control
  - #strong[Pulumi];:
    - Sử dụng ngôn ngữ lập trình thực (Python, JavaScript, Go)
    - Hỗ trợ đa cloud
    - State management tương tự Terraform
- #strong[Nguyên tắc chính];:
  - #strong[Idempotence];: Có thể áp dụng cùng một cấu hình nhiều lần mà
    không gây ra thay đổi
  - #strong[Declarative];: Mô tả trạng thái mong muốn, không phải các
    bước để đạt được
  - #strong[Version Control];: Mã nguồn hạ tầng được quản lý trong hệ
    thống VCS
- #strong[Ưu điểm];:
  - Tính nhất quán và khả năng tái tạo
  - Tự động hóa cao, giảm lỗi do con người
  - Kiểm soát phiên bản và theo dõi thay đổi
  - Documentation as code
- #strong[Nhược điểm];:
  - Đường cong học tập dốc
  - Có thể phức tạp khi quản lý hệ thống lớn
  - Rủi ro nếu state management không đúng

=== Configuration management
<configuration-management>
- #strong[Định nghĩa];: Quản lý cấu hình hệ thống và phần mềm trên nhiều
  máy chủ một cách tự động và đồng nhất.
- #strong[Công cụ phổ biến];:
  - #strong[Ansible];:
    - Không cần agent, sử dụng SSH
    - YAML-based playbooks
    - Ít yêu cầu về hạ tầng
    - Mô hình push configuration

    ```yaml
    ---
    - hosts: webservers
      become: yes
      tasks:
        - name: Install nginx
          apt:
            name: nginx
            state: present
        - name: Start nginx
          service:
            name: nginx
            state: started
            enabled: yes
    ```
  - #strong[Puppet];:
    - Mô hình client-server
    - Ngôn ngữ DSL riêng
    - Hỗ trợ nhiều nền tảng
    - Mô hình pull configuration
  - #strong[Chef];:
    - Sử dụng Ruby DSL
    - Hỗ trợ đa nền tảng
    - \"Recipes\" và \"Cookbooks\"
    - Cộng đồng lớn và nhiều cookbook sẵn có
  - #strong[SaltStack];:
    - Tốc độ cao với ZeroMQ
    - Hỗ trợ cả push và pull
    - YAML based states
    - Remote execution engine
- #strong[Đặc tính chính];:
  - #strong[Idempotence];: Áp dụng cấu hình nhiều lần mà không gây ra
    thay đổi
  - #strong[Desired State Configuration];: Mô tả trạng thái đích, không
    phải các bước để đạt được
  - #strong[Templating];: Sử dụng templates để tạo cấu hình động
  - #strong[Facts/Variables];: Thu thập thông tin về hệ thống để quyết
    định cấu hình
- #strong[Ưu điểm];:
  - Quản lý hạ tầng quy mô lớn hiệu quả
  - Đảm bảo tính nhất quán giữa các môi trường
  - Giảm thiểu lỗi cấu hình thủ công
  - Tự động hóa việc cập nhật và bảo trì
- #strong[Nhược điểm];:
  - Phức tạp khi triển khai ban đầu
  - Yêu cầu kỹ năng chuyên môn
  - Có thể trở nên rắc rối với các hệ thống phức tạp

== Consul
<consul>
#strong[Consul] là một công cụ #strong[service mesh] và #strong[quản lý
dịch vụ phân tán];, giúp thực hiện #strong[service discovery, cấu hình,
quản lý key-value và bảo mật] trong hệ thống microservices. Nó hỗ trợ
#strong[quản lý trạng thái dịch vụ, cân bằng tải, giám sát sức khỏe
(health checks)] và cung cấp #strong[mạng zero-trust với service mesh];.
Consul có thể chạy trên nhiều môi trường, từ #strong[on-premises] đến
#strong[cloud];, giúp các dịch vụ giao tiếp an toàn và hiệu quả.

#align(center)[
  #image("images/2025-03-07-22-32-03.png", width: 5cm)
]

- #strong[Tính năng chính];:
  - #strong[Service Discovery];: Đăng ký và khám phá dịch vụ tự động
  - #strong[Health Checking];: Kiểm tra sức khỏe dịch vụ liên tục
  - #strong[Key-Value Store];: Lưu trữ cấu hình phân tán
  - #strong[Segmentation];: Bảo mật mạng zero-trust với Consul Connect
  - #strong[Multi-datacenter];: Hỗ trợ nhiều trung tâm dữ liệu và khu
    vực
- #strong[Kiến trúc];:
  - #strong[Consul Agent];: Chạy trên mỗi node, có thể ở chế độ client
    hoặc server
  - #strong[Consul Server];: Lưu trữ dữ liệu trong cluster, thực hiện
    consensus
  - #strong[Consensus Protocol];: Sử dụng Raft để đảm bảo tính nhất quán
  - #strong[Gossip Protocol];: Serf, sử dụng để phát hiện lỗi node,
    truyền thông báo
- #strong[Cách sử dụng];:
  - #strong[Đăng ký dịch vụ];:
    ```json
    {
      "service": {
        "name": "web",
        "tags": ["rails"],
        "port": 80,
        "check": {
          "http": "http://localhost:80/health",
          "interval": "10s"
        }
      }
    }
    ```
  - #strong[Truy vấn dịch vụ];:
    ```bash
    curl http://localhost:8500/v1/catalog/service/web
    # hoặc
    consul catalog services
    ```
  - #strong[Lưu trữ key-value];:
    ```bash
    consul kv put config/database/host db.example.com
    consul kv get config/database/host
    ```
- #strong[Tích hợp với các công cụ khác];:
  - Nomad: Orchestration
  - Vault: Bảo mật và quản lý bí mật
  - Terraform: Infrastructure provisioning
  - Kubernetes: Có thể sử dụng làm service catalog
- #strong[Ưu điểm];:
  - Nhẹ và dễ triển khai
  - Không phụ thuộc vào nền tảng cụ thể
  - Hỗ trợ nhiều kiểu kiểm tra sức khỏe
  - Tích hợp DNS cho service discovery
- #strong[Nhược điểm];:
  - Phức tạp khi cấu hình cho hệ thống lớn
  - Yêu cầu quản lý cẩn thận cluster Consul

== Monitoring & Logging
<monitoring--logging>
=== Grafana
<grafana>
- #strong[Tổng quan];: Nền tảng phân tích và trực quan hóa dữ liệu mã
  nguồn mở, đặc biệt mạnh mẽ với dữ liệu time-series.

#image("images/2025-03-07-22-37-24.png")

- #strong[Tính năng chính];:
  - #strong[Dashboards];: Giao diện trực quan với nhiều loại biểu đồ
  - #strong[Data sources];: Hỗ trợ nhiều nguồn dữ liệu (Prometheus,
    InfluxDB, Elasticsearch, MySQL, PostgreSQL...)
  - #strong[Alerting];: Hệ thống cảnh báo linh hoạt
  - #strong[Annotations];: Đánh dấu sự kiện trên biểu đồ
  - #strong[User management];: RBAC, LDAP/Active Directory, OAuth
  - #strong[Plugins];: Mở rộng tính năng qua plugins
- #strong[Use cases];:
  - Giám sát hạ tầng
  - Phân tích hiệu suất ứng dụng
  - Theo dõi business metrics
  - IoT analytics
  - Giám sát bảo mật
- #strong[Cấu hình và triển khai];:
  - #strong[Docker];:
    ```bash
    docker run -d -p 3000:3000 --name=grafana grafana/grafana
    ```
  - #strong[Kubernetes];:
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: grafana
    spec:
      selector:
        matchLabels:
          app: grafana
      template:
        metadata:
          labels:
            app: grafana
        spec:
          containers:
          - name: grafana
            image: grafana/grafana:latest
            ports:
            - containerPort: 3000
    ```
- #strong[Ưu điểm];:
  - Giao diện trực quan mạnh mẽ và thân thiện
  - Hỗ trợ nhiều nguồn dữ liệu
  - Cộng đồng lớn với nhiều dashboard chia sẻ
  - Dễ dàng tùy chỉnh và mở rộng
- #strong[Nhược điểm];:
  - Đôi khi phức tạp khi cấu hình query nâng cao
  - Yêu cầu giải pháp lưu trữ dữ liệu riêng biệt
  - Một số tính năng nâng cao chỉ có trong phiên bản Enterprise

=== Prometheus
<prometheus>
- #strong[Tổng quan];: Hệ thống giám sát và cảnh báo mã nguồn mở, tập
  trung vào reliability và đơn giản.
- #strong[Kiến trúc];:
  - #strong[Prometheus Server];: Thu thập và lưu trữ time series data
  - #strong[Exporters];: Công cụ exposing metrics từ các hệ thống bên
    thứ ba
  - #strong[Alertmanager];: Xử lý cảnh báo
  - #strong[Push Gateway];: Hỗ trợ short-lived jobs
  - #strong[Client Libraries];: Tích hợp ứng dụng với Prometheus
- #strong[Mô hình dữ liệu];:
  - #strong[Metrics];: Đơn vị cơ bản, có tên và nhãn key-value
  - #strong[Types];: Counter, Gauge, Histogram, Summary
  - #strong[PromQL];: Ngôn ngữ truy vấn mạnh mẽ để tương tác với dữ liệu
- #strong[Các exporter phổ biến];:
  - Node Exporter: Metrics về hệ thống (CPU, memory, disk, network)
  - Blackbox Exporter: Giám sát endpoints qua HTTP, HTTPS, DNS, TCP,
    ICMP
  - MySQL Exporter: Metrics từ MySQL server
  - JMX Exporter: Metrics từ Java applications
- #strong[Cấu hình];:
  ```yaml
  global:
    scrape_interval: 15s

  scrape_configs:
    - job_name: 'prometheus'
      static_configs:
        - targets: ['localhost:9090']
    
    - job_name: 'node'
      static_configs:
        - targets: ['node-exporter:9100']

  alerting:
    alertmanagers:
      - static_configs:
        - targets: ['alertmanager:9093']
  ```
- #strong[Service Discovery];:
  - Kubernetes SD
  - Consul SD
  - File-based SD
  - AWS EC2 SD
  - Azure SD
- #strong[Ưu điểm];:
  - Mô hình pull-based đơn giản và đáng tin cậy
  - Lưu trữ dữ liệu hiệu quả
  - Khả năng tự giám sát
  - Tích hợp tốt với Kubernetes
- #strong[Nhược điểm];:
  - Không phù hợp với event logging
  - Retention dài hạn yêu cầu giải pháp lưu trữ bổ sung
  - Đường cong học tập với PromQL
  - Cấu hình phức tạp cho hệ thống lớn

=== Loki
<loki>
- #strong[Tổng quan];: Hệ thống tổng hợp log được thiết kế bởi Grafana
  Labs, lấy cảm hứng từ Prometheus.
- #strong[Đặc điểm chính];:
  - Thiết kế nhẹ và tiết kiệm chi phí
  - Không indexing toàn văn bản, chỉ index metadata
  - Lưu trữ logs theo dạng nén
  - Sử dụng cùng selector và labels như Prometheus
- #strong[Kiến trúc];:
  - #strong[Distributor];: Nhận logs và phân phối đến ingesters
  - #strong[Ingester];: Xử lý và lưu trữ log entries
  - #strong[Querier];: Xử lý các truy vấn từ client
  - #strong[Storage];: Object storage (S3, GCS) cho dữ liệu lâu dài
- #strong[Promtail];: Agent thu thập logs và gửi đến Loki
  ```yaml
  server:
    http_listen_port: 9080

  positions:
    filename: /tmp/positions.yaml

  clients:
    - url: http://loki:3100/loki/api/v1/push

  scrape_configs:
    - job_name: system
      static_configs:
        - targets:
            - localhost
          labels:
            job: varlogs
            __path__: /var/log/*log
  ```
- #strong[LogQL];: Ngôn ngữ truy vấn của Loki
  ```
  {job="varlogs"} |= "error" | json | line_format "{{.message}}"
  ```
- #strong[Triển khai với Helm];:
  ```bash
  helm repo add grafana https://grafana.github.io/helm-charts
  helm install loki grafana/loki-stack
  ```
- #strong[Ưu điểm];:
  - Chi phí lưu trữ thấp
  - Dễ dàng tích hợp với Grafana và hệ sinh thái Prometheus
  - Mở rộng tốt
  - Đơn giản hóa quy trình tìm kiếm log
- #strong[Nhược điểm];:
  - Khả năng tìm kiếm hạn chế hơn so với ELK
  - LogQL ít mạnh mẽ hơn so với Elasticsearch Query DSL
  - Không phù hợp với trường hợp cần phân tích nội dung log phức tạp

=== ELK stack
<elk-stack>
ELK Stack là một bộ công cụ mã nguồn mở gồm ba thành phần chính: Elasticsearch, Logstash và Kibana,
được sử dụng để thu thập, xử lý, lưu trữ và phân tích dữ liệu log theo thời gian thực. 

#image("images/2025-03-07-22-36-34.png")

- #strong[Thành phần];:
  - #strong[Elasticsearch];: Công cụ tìm kiếm và phân tích phân tán
  - #strong[Logstash];: Xử lý và chuyển đổi dữ liệu log
  - #strong[Kibana];: Nền tảng trực quan hóa dữ liệu
  - #strong[Beats];: Lightweight data shippers (Filebeat, Metricbeat,
    Packetbeat, Winlogbeat, ...)

==== Elasticsearch
Elasticsearch là động cơ tìm kiếm và phân tích phân tán, được xây dựng trên
Apache Lucene. Nó lưu trữ dữ liệu dưới dạng các tài liệu JSON và cho phép
tìm kiếm toàn văn bản với hiệu suất cao.
- Đặc điểm chính:
  - Database phân tán dựa trên Lucene
  - Full-text indexing
  - RESTful API
  - Khả năng mở rộng cao

- Cấu trúc:
  - Cluster: Nhóm các node Elasticsearch hoạt động cùng nhau
  - Node: Một máy chủ Elasticsearch đơn lẻ
  - Index: Tập hợp các tài liệu có đặc điểm tương tự
  - Shard: Phân đoạn của index, cho phép phân phối dữ liệu trên nhiều node

==== Logstash
Logstash là công cụ xử lý dữ liệu phía máy chủ để thu thập và chuyển đổi dữ liệu
từ nhiều nguồn khác nhau trước khi đẩy vào Elasticsearch.
  - Input \> Filter \> Output
  - Plugins phong phú
  - Cấu hình:
    ```
    input {
      beats {
        port => 5044
      }
    }

    filter {
      grok {
        match => { "message" => "%{COMBINEDAPACHELOG}" }
      }
      date {
        match => [ "timestamp", "dd/MMM/yyyy:HH:mm:ss Z" ]
      }
    }

    output {
      elasticsearch {
        hosts => ["http://elasticsearch:9200"]
        index => "web-%{+YYYY.MM.dd}"
      }
    }
    ```

==== Kibana
Kibana là nền tảng trực quan hóa và khám phá dữ liệu, giúp tạo dashboard và
biểu đồ từ dữ liệu trong Elasticsearch.
- Tính năng chính:
  - Giao diện web để tìm kiếm, phân tích và trực quan hóa
  - Dashboards
  - Canvas và Lens cho trực quan hóa
  - Management UI cho Elasticsearch
  - Kibana Query Language (KQL)

==== Beats
Beats là các agent nhẹ được cài đặt trên máy chủ để thu thập dữ liệu cụ
thể và gửi trực tiếp đến Elasticsearch hoặc thông qua Logstash.

- Các loại phổ biến:
  - Filebeat: Log files
  - Metricbeat: Metrics
  - Packetbeat: Network data
  - Auditbeat: Audit data
  - Heartbeat: Uptime monitoring

==== Triển khai
  - Docker Compose:
    ```yaml
    services:
      elasticsearch:
        image: docker.elastic.co/elasticsearch/elasticsearch:7.17.0
        environment:
          - discovery.type=single-node
        ports:
          - 9200:9200
      
      kibana:
        image: docker.elastic.co/kibana/kibana:7.17.0
        ports:
          - 5601:5601
        depends_on:
          - elasticsearch
      
      logstash:
        image: docker.elastic.co/logstash/logstash:7.17.0
        ports:
          - 5044:5044
        depends_on:
          - elasticsearch
    ```

=== OpenTelemetry & Jaeger
<opentelemetry--jaeger>
==== OpenTelemetry
<opentelemetry>
#strong[OpenTelemetry] là một bộ công cụ #strong[mã nguồn mở] dùng để
thu thập, xử lý và xuất dữ liệu #strong[quan sát (Observability)] từ các
ứng dụng, bao gồm #strong[logs, metrics và traces];. Nó giúp theo dõi
hiệu suất hệ thống, phát hiện lỗi và cải thiện khả năng quan sát trong
môi trường #strong[phân tán và microservices];. OpenTelemetry hỗ trợ
nhiều nền tảng, tích hợp với các hệ thống giám sát như
#strong[Prometheus, Jaeger, Grafana] và là tiêu chuẩn phổ biến trong
việc theo dõi ứng dụng hiện đại.


#image("images/2025-03-07-22-34-57.png")

#strong[Thành phần chính:]

- API & SDK: Các giao diện và thư viện để lập trình viên công cụ hóa mã
  nguồn
- Collector: Nhận, xử lý và xuất dữ liệu telemetry đến nhiều backend
  khác nhau
- Instrumentation: Thư viện tự động công cụ hóa cho các framework và thư
  viện phổ biến

#strong[Dữ liệu thu thập:]

- Traces: Thông tin về các yêu cầu khi chúng di chuyển qua dịch vụ và
  thành phần
- Metrics: Số liệu về hiệu suất và sức khỏe của hệ thống
- Logs: Bản ghi sự kiện và thông tin gỡ lỗi

#strong[Lợi ích:]

- Triển khai và thiết lập chuẩn hóa cho telemetry
- Tích hợp với nhiều backend giám sát và phân tích
- Giảm sự phụ thuộc vào nhà cung cấp với định dạng dữ liệu tiêu chuẩn
- Hỗ trợ nhiều ngôn ngữ lập trình và framework

#strong[Triển khai OpenTelemetry:]

+ Công cụ hóa ứng dụng với OpenTelemetry SDK
+ Cấu hình OpenTelemetry Collector
+ Định cấu hình xuất dữ liệu đến backend phân tích (Jaeger, Prometheus,
  v.v.)
+ Thiết lập sampling và lọc để quản lý khối lượng dữ liệu

==== Jaeger
<jaeger>
Jaeger là hệ thống tracing phân tán mã nguồn mở, được tạo ra bởi Uber và
hiện là dự án tốt nghiệp của Cloud Native Computing Foundation (CNCF).

#image("images/2025-03-07-22-35-28.png")

#strong[Kiến trúc:]

- Jaeger Client: Thư viện được tích hợp vào ứng dụng để tạo span
- Jaeger Agent: Dịch vụ mạng nhận span từ client và chuyển tiếp đến
  collector
- Jaeger Collector: Nhận trace từ agent và xử lý để lưu trữ
- Storage: Backend lưu trữ (Elasticsearch, Cassandra, hoặc Badger)
- Jaeger Query: Dịch vụ truy vấn từ storage và phục vụ UI
- Jaeger UI: Giao diện người dùng để tìm kiếm và phân tích trace

#strong[Tính năng chính:]

- Truy tìm gốc của yêu cầu trễ và lỗi
- Phân tích luồng dịch vụ và phát hiện điểm nghẽn
- Theo dõi mối quan hệ nhân quả giữa các sự kiện
- Tương thích với chuẩn OpenTracing và OpenTelemetry

#strong[Các trường hợp sử dụng:]

- Giám sát độ trễ giữa các dịch vụ trong kiến trúc microservice
- Phân tích gốc rễ nguyên nhân của lỗi hệ thống
- Tối ưu hóa hiệu suất dựa trên dữ liệu thực tế
- Hiểu được các phụ thuộc giữa các dịch vụ

#strong[Triển khai Jaeger với Kubernetes:]

+ Triển khai bằng Jaeger Operator
+ Cấu hình Jaeger Agent như sidecar trong pod
+ Tích hợp với OpenTelemetry Collector
+ Thiết lập kết nối với backend lưu trữ
