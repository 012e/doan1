= Xây dựng hệ thống với .NET Core
<xây-dựng-hệ-thống-với-net-core>
== ASP.NET Core
<aspnet-core>
ASP.NET Core là một framework mã nguồn mở, đa nền tảng để xây dựng các
ứng dụng web hiện đại kết nối Internet. ASP.NET Core là phiên bản thiết
kế lại của ASP.NET 4.x với những thay đổi kiến trúc mang lại framework
gọn nhẹ hơn và module hóa.

ASP.NET Core cung cấp các lợi ích sau:

- Hỗ trợ đa nền tảng: có thể chạy trên Windows, macOS và Linux
- Hiệu suất cao hơn so với ASP.NET 4.x
- Hỗ trợ phát triển và chạy đồng thời nhiều phiên bản
- Hệ thống cấu hình linh hoạt dựa trên môi trường
- Tích hợp với các hệ thống container hiện đại
- Hỗ trợ API RESTful, MVC, Razor Pages, Blazor và nhiều mô hình khác
- Tích hợp với các dịch vụ đám mây một cách liền mạch

=== Service & Dependency Injection
<service--dependency-injection>
Dependency Injection (DI) là một kỹ thuật thiết kế phần mềm quan trọng
và là một phần cốt lõi của ASP.NET Core. Framework này cung cấp
container DI tích hợp sẵn, giúp quản lý các dependency và vòng đời của
các service.

ASP.NET Core hỗ trợ ba kiểu đăng ký service:

+ #strong[Transient];: Dịch vụ được tạo mới mỗi khi được yêu cầu. Phù
  hợp với các dịch vụ nhẹ, không trạng thái.

```cs
services.AddTransient<ITransientService, TransientService>();
```

#block[
#set enum(numbering: "1.", start: 2)
+ #strong[Scoped];: Dịch vụ được tạo một lần cho mỗi request. Rất hữu
  ích cho các dịch vụ cần duy trì trạng thái trong suốt một request.
]

```cs
services.AddScoped<IScopedService, ScopedService>();
```

#block[
#set enum(numbering: "1.", start: 3)
+ #strong[Singleton];: Dịch vụ được tạo một lần duy nhất và được sử dụng
  xuyên suốt vòng đời của ứng dụng.
]

```cs
services.AddSingleton<ISingletonService, SingletonService>();
```

DI trong ASP.NET Core thúc đẩy nguyên tắc thiết kế hướng đến interface,
giúp tăng khả năng kiểm thử và bảo trì mã nguồn. Nó cũng hỗ trợ đăng ký
dịch vụ theo nhiều cách khác nhau, bao gồm đăng ký instance, factory
function, hoặc thông qua interface.

=== Middleware
<middleware>
Middleware là các thành phần phần mềm được kết nối với nhau trong
pipeline xử lý HTTP của ASP.NET Core. Mỗi thành phần middleware thực
hiện một chức năng cụ thể trong quá trình xử lý request và response.

Pipeline middleware hoạt động theo mô hình \"first in, first out\"
(FIFO), nơi mỗi middleware có thể:

- Xử lý request trước khi chuyển đến middleware tiếp theo
- Quyết định có chuyển request đến middleware tiếp theo hay không
- Thực hiện các tác vụ sau khi middleware tiếp theo đã xử lý xong

Một middleware điển hình có thể được triển khai như sau:

```cs
public class CustomMiddleware
{
    private readonly RequestDelegate _next;

    public CustomMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        // Logic xử lý trước khi chuyển đến middleware tiếp theo
        
        await _next(context); // Gọi middleware tiếp theo
        
        // Logic xử lý sau khi middleware tiếp theo đã xử lý xong
    }
}

// Mở rộng để đăng ký middleware
public static class CustomMiddlewareExtensions
{
    public static IApplicationBuilder UseCustomMiddleware(this IApplicationBuilder builder)
    {
        return builder.UseMiddleware<CustomMiddleware>();
    }
}
```

ASP.NET Core cung cấp nhiều middleware tích hợp sẵn cho các tác vụ phổ
biến như xác thực, phân quyền, định tuyến, xử lý ngoại lệ, nén dữ liệu,
phục vụ tệp tĩnh và CORS.

=== Caching
<caching>
Caching là kỹ thuật quan trọng để tối ưu hóa hiệu suất ứng dụng ASP.NET
Core. Framework này cung cấp nhiều lựa chọn caching khác nhau:

+ #strong[In-Memory Cache];: Lưu trữ dữ liệu trong bộ nhớ của máy chủ.
  Đơn giản nhưng chỉ phù hợp cho ứng dụng đơn server.

```cs
services.AddMemoryCache();
// Sử dụng
var cacheEntry = _cache.GetOrCreate(cacheKey, entry =>
{
    entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
    return ComputeExpensiveValue();
});
```

#block[
#set enum(numbering: "1.", start: 2)
+ #strong[Distributed Cache];: Cho phép chia sẻ cache giữa nhiều
  instance của ứng dụng. ASP.NET Core hỗ trợ nhiều triển khai, bao gồm:
  - SQL Server
  - Redis
  - NCache
]

```cs
// Đăng ký Redis Cache
services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = "localhost:6379";
    options.InstanceName = "MyApplicationCache";
});

// Sử dụng
await _distributedCache.SetStringAsync(cacheKey, jsonData, options);
```

#block[
#set enum(numbering: "1.", start: 3)
+ #strong[Response Caching];: Cache các HTTP response để tránh phải xử
  lý lại các request giống nhau.
]

```cs
services.AddResponseCaching();
// Trong Controller
[ResponseCache(Duration = 60)]
public IActionResult Index()
{
    return View();
}
```

#block[
#set enum(numbering: "1.", start: 4)
+ #strong[Data Caching with Entity Framework];: Cache kết quả truy vấn
  để giảm tải database.
]

```cs
var blogs = await _context.Blogs
    .Where(b => b.Rating > 3)
    .TagWith("GetHighRatedBlogs")
    .ToListAsync();
```

ASP.NET Core cũng hỗ trợ caching phía client thông qua HTTP headers và
cơ chế caching tùy chỉnh.

=== SignalR
<signalr>
ASP.NET Core SignalR là một thư viện mạnh mẽ cho phép giao tiếp hai
chiều thời gian thực giữa server và client. SignalR đặc biệt hữu ích cho
các ứng dụng cần cập nhật dữ liệu tức thì như trò chuyện, bảng điều
khiển, trò chơi và thông báo.

SignalR tự động xử lý kết nối, quản lý và mở rộng. Nó cũng tự động chọn
phương thức truyền tải phù hợp nhất dựa trên khả năng của server và
client:

- WebSockets (ưu tiên khi được hỗ trợ)
- Server-Sent Events
- Long Polling

Cách thiết lập SignalR:

```cs
// Đăng ký dịch vụ
services.AddSignalR();

// Cấu hình endpoint
app.UseEndpoints(endpoints =>
{
    endpoints.MapHub<ChatHub>("/chatHub");
});
```

Triển khai Hub:

```cs
public class ChatHub : Hub
{
    public async Task SendMessage(string user, string message)
    {
        // Gửi tin nhắn đến tất cả client
        await Clients.All.SendAsync("ReceiveMessage", user, message);
        
        // Hoặc gửi đến một nhóm cụ thể
        // await Clients.Group("groupName").SendAsync("ReceiveMessage", user, message);
    }
    
    public async Task JoinGroup(string groupName)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
    }
    
    public override async Task OnConnectedAsync()
    {
        // Xử lý khi client kết nối
        await base.OnConnectedAsync();
    }
}
```

SignalR trong ASP.NET Core còn cung cấp nhiều tính năng nâng cao như xác
thực, phân quyền, mã hóa, mở rộng quy mô với Redis backplane, và
streaming dữ liệu lớn.

== ORM
<orm>
ORM (Object-Relational Mapping) là kỹ thuật cho phép làm việc với cơ sở
dữ liệu quan hệ thông qua các đối tượng. .NET Core hỗ trợ nhiều
framework ORM, mỗi framework có điểm mạnh và phù hợp với các tình huống
khác nhau.

=== Entity Framework Core
<entity-framework-core>
Entity Framework Core (EF Core) là ORM hiện đại, nhẹ, mở rộng được và đa
nền tảng của Microsoft. Nó là phiên bản thiết kế lại hoàn toàn của
Entity Framework 6.x.

EF Core sử dụng mô hình làm việc thông qua DbContext và các entity được
định nghĩa dưới dạng class:

```cs
public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    { }
    
    public DbSet<Blog> Blogs { get; set; }
    public DbSet<Post> Posts { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Blog>()
            .HasMany(b => b.Posts)
            .WithOne(p => p.Blog)
            .HasForeignKey(p => p.BlogId);
            
        modelBuilder.Entity<Blog>()
            .HasIndex(b => b.Url)
            .IsUnique();
    }
}
```

EF Core hỗ trợ hai cách tiếp cận chính:

+ #strong[Code First];: Định nghĩa các entity bằng code và tạo/cập nhật
  database từ đó.
+ #strong[Database First];: Tạo các entity từ database hiện có.

EF Core hỗ trợ nhiều tính năng quan trọng:

- #strong[Migrations];: Quản lý phiên bản schema database
- #strong[Change Tracking];: Theo dõi thay đổi của entity
- #strong[Lazy Loading];: Tải dữ liệu liên quan theo yêu cầu
- #strong[Eager Loading];: Tải trước dữ liệu liên quan
- #strong[Query Translation];: Chuyển đổi LINQ thành SQL
- #strong[Concurrency Resolution];: Xử lý xung đột đồng thời

EF Core hỗ trợ nhiều database provider như SQL Server, SQLite,
PostgreSQL, MySQL, Oracle và nhiều provider khác từ cộng đồng.

=== Dapper
<dapper>
Dapper là một micro-ORM đơn giản, hiệu suất cao, tập trung vào tốc độ và
tinh gọn. Được phát triển bởi đội ngũ Stack Overflow, Dapper cung cấp
phương thức mở rộng cho IDbConnection giúp ánh xạ dữ liệu từ câu truy
vấn SQL vào các đối tượng.

Ưu điểm chính của Dapper:

- #strong[Hiệu suất cực kỳ cao];: Gần với ADO.NET thuần túy
- #strong[Đơn giản];: API nhỏ gọn, dễ học
- #strong[Kiểm soát SQL];: Viết câu truy vấn SQL trực tiếp
- #strong[Hỗ trợ thủ tục lưu trữ và các tính năng database nâng cao]

Ví dụ sử dụng Dapper:

```cs
public async Task<IEnumerable<Product>> GetProductsByCategoryAsync(int categoryId)
{
    using var connection = new SqlConnection(_connectionString);
    await connection.OpenAsync();
    
    return await connection.QueryAsync<Product>(
        "SELECT * FROM Products WHERE CategoryId = @CategoryId",
        new { CategoryId = categoryId }
    );
}

public async Task<int> CreateProductAsync(Product product)
{
    using var connection = new SqlConnection(_connectionString);
    await connection.OpenAsync();
    
    return await connection.ExecuteAsync(
        "INSERT INTO Products (Name, Price, CategoryId) VALUES (@Name, @Price, @CategoryId)",
        product
    );
}
```

Dapper còn hỗ trợ:

- #strong[Multi-mapping];: Ánh xạ một hàng vào nhiều đối tượng
- #strong[Multi-result];: Xử lý nhiều tập kết quả từ một câu truy vấn
- #strong[Transactions];: Quản lý giao dịch
- #strong[Async];: Hỗ trợ đầy đủ các phương thức bất đồng bộ

Dapper là lựa chọn tuyệt vời khi cần hiệu suất cao và kiểm soát SQL hoàn
toàn.

=== NHibernate
<nhibernate>
NHibernate là một ORM trưởng thành, đầy đủ tính năng cho .NET, là bản
chuyển đổi từ Hibernate trong Java. NHibernate cung cấp một giải pháp
toàn diện cho việc ánh xạ object-relational.

Cấu trúc của NHibernate bao gồm:

- #strong[SessionFactory];: Tạo và quản lý các Session
- #strong[Session];: Cung cấp các phương thức CRUD và truy vấn
- #strong[Mapping];: Định nghĩa cách ánh xạ đối tượng vào database

Ví dụ cấu hình và sử dụng NHibernate:

```cs
// Cấu hình
var configuration = new Configuration();
configuration.Configure("hibernate.cfg.xml");
configuration.AddAssembly(typeof(Product).Assembly);

// Tạo SessionFactory
var sessionFactory = configuration.BuildSessionFactory();

// Truy vấn dữ liệu
using (var session = sessionFactory.OpenSession())
using (var transaction = session.BeginTransaction())
{
    var products = session.Query<Product>()
        .Where(p => p.Category.Id == categoryId)
        .ToList();
        
    transaction.Commit();
    return products;
}
```

NHibernate có những ưu điểm:

- #strong[Mapping linh hoạt];: Hỗ trợ XML, Fluent API và Attributes
- #strong[Caching nhiều cấp độ];: Session cache và second-level cache
- #strong[HQL/LINQ];: Hỗ trợ nhiều cách truy vấn
- #strong[Lazy Loading];: Tải dữ liệu chỉ khi cần
- #strong[Interceptors];: Mở rộng hành vi mặc định

NHibernate phù hợp với các dự án lớn, phức tạp cần nhiều tính năng nâng
cao của ORM.

=== So sánh
<so-sánh>
Khi lựa chọn ORM cho dự án .NET Core, cần xem xét nhiều yếu tố. Dưới đây
là so sánh giữa Entity Framework Core, Dapper và NHibernate:

#strong[Hiệu suất];:

- Dapper nhanh nhất và gần với ADO.NET thuần túy
- EF Core hiệu suất tốt hơn nhiều so với EF6
- NHibernate có hiệu suất tốt nhưng thường chậm hơn Dapper

#strong[Đường cong học tập];:

- Dapper dễ học nhất với API đơn giản
- EF Core có độ phức tạp trung bình, được tài liệu hóa tốt
- NHibernate có đường cong học tập dốc nhất

#strong[Tính năng];:

- EF Core cung cấp cân bằng tốt giữa tính năng và đơn giản
- NHibernate có nhiều tính năng nâng cao nhất
- Dapper tối giản nhưng rất linh hoạt

#strong[Hỗ trợ database];:

- EF Core hỗ trợ nhiều loại database nhất qua providers
- Dapper hoạt động với bất kỳ database nào có ADO.NET provider
- NHibernate cũng hỗ trợ nhiều database

#strong[Kiểm soát SQL];:

- Dapper cung cấp kiểm soát SQL tuyệt đối
- NHibernate cho phép tinh chỉnh SQL khi cần
- EF Core cũng cho phép can thiệp SQL nhưng ít trực tiếp hơn

#strong[Khi nào sử dụng];:

- #strong[Entity Framework Core];: Phù hợp với hầu hết các dự án, đặc
  biệt khi cần cân bằng giữa năng suất và hiệu suất
- #strong[Dapper];: Lý tưởng cho các thành phần cần hiệu suất cực cao,
  API, microservices
- #strong[NHibernate];: Tốt cho các ứng dụng doanh nghiệp lớn với logic
  domain phức tạp

Trong thực tế, nhiều dự án kết hợp các ORM, sử dụng EF Core cho phần lớn
công việc và Dapper cho các truy vấn cần hiệu suất cao.

== Architecture
<architecture>
Kiến trúc phần mềm định nghĩa cấu trúc tổng thể của hệ thống, tổ chức
các thành phần và mối quan hệ giữa chúng. Trong hệ sinh thái .NET Core,
có nhiều mẫu kiến trúc phổ biến, mỗi mẫu có điểm mạnh và trường hợp sử
dụng riêng.

=== Clean Architecture
<clean-architecture>
Clean Architecture là một mẫu kiến trúc được đề xuất bởi Robert C.
Martin (Uncle Bob). Mục tiêu chính là tạo ra các hệ thống:

- #strong[Độc lập với framework];: Kiến trúc không phụ thuộc vào sự tồn
  tại của thư viện
- #strong[Có thể kiểm thử];: Logic nghiệp vụ có thể được kiểm thử mà
  không cần UI, database, web server
- #strong[Độc lập với UI];: UI có thể thay đổi mà không ảnh hưởng đến
  phần còn lại của hệ thống
- #strong[Độc lập với database];: Có thể thay đổi database mà không ảnh
  hưởng logic nghiệp vụ
- #strong[Độc lập với bất kỳ thành phần bên ngoài nào]

#image("images/2025-03-07-22-38-13.png")

Clean Architecture trong .NET Core thường được tổ chức thành các lớp
đồng tâm:

+ #strong[Domain Layer];: Ở trung tâm, chứa các entities, value objects,
  và domain events. Không phụ thuộc vào bất kỳ lớp nào khác.

```cs
public class Order
{
    public Guid Id { get; private set; }
    public Customer Customer { get; private set; }
    public IReadOnlyCollection<OrderItem> Items => _items.AsReadOnly();
    public OrderStatus Status { get; private set; }
    
    private readonly List<OrderItem> _items = new List<OrderItem>();
    
    public Order(Customer customer)
    {
        Id = Guid.NewGuid();
        Customer = customer;
        Status = OrderStatus.Draft;
    }
    
    public void AddItem(Product product, int quantity)
    {
        var existingItem = _items.FirstOrDefault(i => i.Product.Id == product.Id);
        if (existingItem != null)
        {
            existingItem.IncreaseQuantity(quantity);
        }
        else
        {
            _items.Add(new OrderItem(this, product, quantity));
        }
    }
    
    public void ConfirmOrder()
    {
        // Domain logic và validation
        if (!Items.Any())
            throw new OrderingDomainException("Order must have at least one item");
            
        Status = OrderStatus.Confirmed;
    }
}
```

#block[
#set enum(numbering: "1.", start: 2)
+ #strong[Application Layer];: Chứa use cases, interfaces repository và
  services. Điều phối luồng dữ liệu từ và đến domain entities.
]

```cs
public class CreateOrderCommand : IRequest<Guid>
{
    public string CustomerId { get; set; }
    public List<OrderItemDto> Items { get; set; }
}

public class CreateOrderCommandHandler : IRequestHandler<CreateOrderCommand, Guid>
{
    private readonly IOrderRepository _orderRepository;
    private readonly ICustomerRepository _customerRepository;
    private readonly IProductRepository _productRepository;
    
    public CreateOrderCommandHandler(
        IOrderRepository orderRepository,
        ICustomerRepository customerRepository,
        IProductRepository productRepository)
    {
        _orderRepository = orderRepository;
        _customerRepository = customerRepository;
        _productRepository = productRepository;
    }
    
    public async Task<Guid> Handle(CreateOrderCommand request, CancellationToken cancellationToken)
    {
        var customer = await _customerRepository.GetByIdAsync(request.CustomerId);
        if (customer == null)
            throw new NotFoundException(nameof(Customer), request.CustomerId);
            
        var order = new Order(customer);
        
        foreach (var item in request.Items)
        {
            var product = await _productRepository.GetByIdAsync(item.ProductId);
            if (product == null)
                throw new NotFoundException(nameof(Product), item.ProductId);
                
            order.AddItem(product, item.Quantity);
        }
        
        order.ConfirmOrder();
        
        _orderRepository.Add(order);
        await _orderRepository.UnitOfWork.SaveChangesAsync(cancellationToken);
        
        return order.Id;
    }
}
```

#block[
#set enum(numbering: "1.", start: 3)
+ #strong[Infrastructure Layer];: Triển khai các interfaces được định
  nghĩa trong application layer. Chứa database context, repositories,
  external services, logging, v.v.
]

```cs
public class OrderRepository : IOrderRepository
{
    private readonly ApplicationDbContext _context;
    
    public OrderRepository(ApplicationDbContext context)
    {
        _context = context;
        UnitOfWork = context;
    }
    
    public IUnitOfWork UnitOfWork => _context;
    
    public async Task<Order> GetByIdAsync(Guid id)
    {
        return await _context.Orders
            .Include(o => o.Customer)
            .Include(o => o.Items)
            .ThenInclude(i => i.Product)
            .FirstOrDefaultAsync(o => o.Id == id);
    }
    
    public Order Add(Order order)
    {
        return _context.Orders.Add(order).Entity;
    }
}
```

#block[
#set enum(numbering: "1.", start: 4)
+ #strong[Presentation Layer];: Web API, MVC UI, hoặc Blazor. Chuyển đổi
  dữ liệu từ application layer thành định dạng phù hợp với người dùng.
]

```cs
[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly IMediator _mediator;
    
    public OrdersController(IMediator mediator)
    {
        _mediator = mediator;
    }
    
    [HttpPost]
    public async Task<ActionResult<Guid>> Create(CreateOrderCommand command)
    {
        var orderId = await _mediator.Send(command);
        return Ok(orderId);
    }
}
```

Clean Architecture mang lại nhiều lợi ích:

- Dễ bảo trì và mở rộng
- Cô lập các thay đổi
- Kiểm thử dễ dàng
- Độc lập với các chi tiết triển khai
- Tập trung vào business logic

Tuy nhiên, nó cũng có thể dẫn đến quá nhiều abstraction và phức tạp cho
các ứng dụng nhỏ.

=== Vertical Slice Architecture
<vertical-slice-architecture>
Vertical Slice Architecture (VSA) là một cách tiếp cận khác biệt so với
kiến trúc phân lớp truyền thống. Thay vì tổ chức code theo các lớp kỹ
thuật (controllers, services, repositories), VSA tổ chức code theo tính
năng hoặc \"vertical slice\" của ứng dụng.

Nguyên tắc cơ bản:

- #strong[Tổ chức theo tính năng];: Mỗi vertical slice đại diện cho một
  tính năng hoàn chỉnh
- #strong[Giảm thiểu sự phụ thuộc giữa các slice];: Mỗi slice nên độc
  lập càng nhiều càng tốt
- #strong[Tách biệt mối quan tâm kỹ thuật trong phạm vi slice];: Mỗi
  slice chịu trách nhiệm về mọi khía cạnh của tính năng

#image("images/2025-03-07-22-38-38.png")

Trong .NET Core, VSA thường được triển khai bằng cách sử dụng thư viện
MediatR và CQRS (Command Query Responsibility Segregation):

```cs
// Features/Products/List/
public class ListProductsQuery : IRequest<List<ProductDto>> 
{
    public string SearchTerm { get; set; }
    public int? CategoryId { get; set; }
}

public class ListProductsQueryHandler : IRequestHandler<ListProductsQuery, List<ProductDto>>
{
    private readonly ApplicationDbContext _db;
    private readonly IMapper _mapper;
    
    public ListProductsQueryHandler(ApplicationDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }
    
    public async Task<List<ProductDto>> Handle(ListProductsQuery request, CancellationToken cancellationToken)
    {
        var query = _db.Products.AsQueryable();
        
        if (!string.IsNullOrEmpty(request.SearchTerm))
        {
            query = query.Where(p => p.Name.Contains(request.SearchTerm));
        }
        
        if (request.CategoryId.HasValue)
        {
            query = query.Where(p => p.CategoryId == request.CategoryId.Value);
        }
        
        var products = await query
            .OrderBy(p => p.Name)
            .ToListAsync(cancellationToken);
            
        return _mapper.Map<List<ProductDto>>(products);
    }
}

// Features/Products/Create/
public class CreateProductCommand : IRequest<int>
{
    public string Name { get; set; }
    public decimal Price { get; set; }
    public int CategoryId { get; set; }
}

public class CreateProductCommandValidator : AbstractValidator<CreateProductCommand>
{
    public CreateProductCommandValidator()
    {
        RuleFor(p => p.Name).NotEmpty().MaximumLength(100);
        RuleFor(p => p.Price).GreaterThan(0);
        RuleFor(p => p.CategoryId).GreaterThan(0);
    }
}

public class CreateProductCommandHandler : IRequestHandler<CreateProductCommand, int>
{
    private readonly ApplicationDbContext _db;
    
    public CreateProductCommandHandler(ApplicationDbContext db)
    {
        _db = db;
    }
    
    public async Task<int> Handle(CreateProductCommand request, CancellationToken cancellationToken)
    {
        var product = new Product
        {
            Name = request.Name,
            Price = request.Price,
            CategoryId = request.CategoryId
        };
        
        _db.Products.Add(product);
        await _db.SaveChangesAsync(cancellationToken);
        
        return product.Id;
    }
}

// API Controller
[ApiController]
[Route("api/products")]
public class ProductsController : ControllerBase
{
    private readonly IMediator _mediator;
    
    public ProductsController(IMediator mediator)
    {
        _mediator = mediator;
    }
    
    [HttpGet]
    public async Task<ActionResult<List<ProductDto>>> List([FromQuery] ListProductsQuery query)
    {
        return await _mediator.Send(query);
    }
    
    [HttpPost]
    public async Task<ActionResult<int>> Create(CreateProductCommand command)
    {
        return await _mediator.Send(command);
    }
}
```

Ưu điểm của VSA:

- #strong[Tập trung vào tính năng];: Dễ dàng tìm và hiểu tất cả code
  liên quan đến một tính năng
- #strong[Giảm thiểu sự phụ thuộc vượt ranh giới];: Sửa đổi một tính
  năng ít ảnh hưởng đến tính năng khác
- #strong[Refactoring đơn giản];: Có thể refactor một tính năng mà không
  ảnh hưởng đến các tính năng khác
- #strong[Phát triển song song];: Các team có thể làm việc trên các tính
  năng khác nhau độc lập

Nhược điểm:

- Có thể dẫn đến trùng lặp code
- Khó duy trì tính nhất quán giữa các slice
- Tiềm ẩn tạo ra các \"island of functionality\" thiếu sự liên kết

VSA đặc biệt phù hợp với các ứng dụng lớn, có nhiều tính năng độc lập và
dự án có nhiều đội phát triển làm việc song song.

== Deployment
<deployment>
Triển khai ứng dụng .NET Core có nhiều lựa chọn khác nhau, từ các phương
pháp truyền thống đến các giải pháp container và cloud-native hiện đại.
Những giải pháp này cho phép tối ưu hóa việc triển khai, mở rộng quy mô
và quản lý ứng dụng trong môi trường sản xuất.

=== Docker/Kubernetes
<dockerkubernetes>
Docker và Kubernetes là hai công nghệ container quan trọng đã thay đổi
cách chúng ta triển khai ứng dụng .NET Core.

#strong[Docker] cho phép đóng gói ứng dụng và tất cả dependencies của nó
vào một container độc lập, đảm bảo ứng dụng chạy nhất quán trong bất kỳ
môi trường nào.

Một Dockerfile cơ bản cho ứng dụng ASP.NET Core:

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["MyApp.csproj", "./"]
RUN dotnet restore "MyApp.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "MyApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyApp.dll"]
```

Sử dụng Docker với .NET Core mang lại nhiều lợi ích:

- Môi trường đồng nhất từ phát triển đến sản xuất
- Cô lập ứng dụng và dependencies
- Triển khai nhanh và nhất quán
- Hiệu quả về tài nguyên
- Tích hợp tốt với CI/CD

#strong[Kubernetes] là nền tảng điều phối container mạnh mẽ, giúp quản
lý và mở rộng các ứng dụng container hóa.

Ví dụ về file YAML triển khai ứng dụng ASP.NET Core trên Kubernetes:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myregistry.azurecr.io/myapp:latest
        ports:
        - containerPort: 80
        resources:
          limits:
            cpu: "1"
            memory: "512Mi"
          requests:
            cpu: "0.5"
            memory: "256Mi"
        env:
        - name: ASPNETCORE_ENVIRONMENT
          value: "Production"
        livenessProbe:
          httpGet:
            path: /health/live
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health/ready
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

Kubernetes cung cấp nhiều tính năng cho ứng dụng .NET Core:

- #strong[Tự động mở rộng];: Tăng/giảm số lượng pods dựa trên tải
- #strong[Self-healing];: Tự động khởi động lại containers bị lỗi
- #strong[Rolling updates];: Cập nhật ứng dụng không gián đoạn
- #strong[Service discovery];: Định vị services một cách năng động
- #strong[Load balancing];: Phân phối tải giữa các instances
- #strong[Secrets management];: Quản lý thông tin nhạy cảm an toàn

.NET Core hỗ trợ tốt cho Docker và Kubernetes thông qua:

- Hình ảnh container chính thức tối ưu hóa
- Health checks tích hợp cho liveness và readiness probes
- Configuration providers cho Kubernetes ConfigMaps và Secrets
- Tích hợp logging với container logs

Kết hợp .NET Core, Docker và Kubernetes tạo nền tảng mạnh mẽ cho việc
xây dựng và triển khai các ứng dụng microservices có khả năng mở rộng
cao.

=== Aspire
<aspire>
.NET Aspire là một nền tảng mới từ Microsoft giới thiệu vào cuối năm
2023, được thiết kế để đơn giản hóa quá trình xây dựng, triển khai và
vận hành các ứng dụng phân tán, cloud-native .NET.

Aspire cung cấp một stack toàn diện cho phát triển cloud-native bao gồm:

- #strong[Orchestrator];: Quản lý và chạy các thành phần ứng dụng
- #strong[Dashboard];: Giao diện trực quan để giám sát và gỡ lỗi
- #strong[Components Library];: Các thành phần tái sử dụng cho dịch vụ
  phổ biến
- #strong[Mẫu ứng dụng];: Các blueprints để bắt đầu nhanh chóng

Ví dụ về cách thiết lập một dự án .NET Aspire:

```cs
// AppHost.cs
public class Program
{
    public static void Main(string[] args)
    {
        var builder = Host.CreateApplicationBuilder(args);
        builder.Environment.ContentRootPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

        var appHost = builder.Build();
        
        var catalogApi = appHost.CreateProject("catalogapi", "CatalogApi");
        var basketApi = appHost.CreateProject("basketapi", "BasketApi");
        var webApp = appHost.CreateProject("webapp", "WebApp");
        
        // Thêm Redis cho BasketApi
        var redis = appHost.AddRedis("redis");
        basketApi.WithReference(redis);
        
        // Thêm SQL Server cho CatalogApi
        var sqlServer = appHost.AddSqlServer("sql").AddDatabase("CatalogDb");
        catalogApi.WithReference(sqlServer);
        
        // Cấu hình dependency giữa các services
        webApp.WithReference(catalogApi);
        webApp.WithReference(basketApi);
        
        appHost.Run();
    }
}
```

Trong các dự án cụ thể, Aspire Components cung cấp extension methods để
cấu hình services:

```cs
// BasketApi/Program.cs
var builder = WebApplication.CreateBuilder(args);

// Thêm Redis cho caching
builder.AddRedisClient("redis");

// Đăng ký health checks
builder.Services.AddHealthChecks()
    .AddRedis(builder.Configuration.GetConnectionString("redis"));

// ...
```

.NET Aspire mang lại nhiều lợi ích:

- #strong[Phát triển đơn giản];: Xây dựng ứng dụng phân tán mà không cần
  cấu hình phức tạp
- #strong[Thiết kế cloud-native];: Hỗ trợ các mẫu thiết kế hiện đại như
  health checks, telemetry
- #strong[Developer experience nâng cao];: Dashboard trực quan để giám
  sát và gỡ lỗi
- #strong[Khả năng mở rộng];: Dễ dàng thêm services mới và tích hợp với
  hệ sinh thái .NET
- #strong[Đường dẫn rõ ràng đến Kubernetes];: Cung cấp các công cụ để
  tạo manifest Kubernetes

Aspire đặc biệt phù hợp với các trường hợp:

- Phát triển ứng dụng phân tán mới (microservices)
- Hiện đại hóa ứng dụng .NET hiện có
- Cung cấp môi trường phát triển local gần với production
- Tối ưu hóa quá trình từ phát triển đến sản xuất

.NET Aspire đang ngày càng phát triển và đã trở thành một phần quan
trọng trong chiến lược cloud-native của Microsoft cho .NET.

== Thiết kế hệ thống lớn
<thiết-kế-hệ-thống-lớn>
Thiết kế hệ thống lớn với .NET Core yêu cầu sự kết hợp của nhiều nguyên
tắc, mẫu và kỹ thuật để đảm bảo khả năng mở rộng, bảo trì và hiệu suất.
Dưới đây là các khía cạnh quan trọng cần xem xét:

=== Kiến trúc Microservices
<kiến-trúc-microservices>
Microservices là một phong cách kiến trúc phân tách ứng dụng thành các
dịch vụ nhỏ, có thể triển khai độc lập. .NET Core rất phù hợp cho kiến
trúc microservices với:

- #strong[Service Discovery];: Sử dụng Consul, Kubernetes hoặc Azure
  Service Fabric
- #strong[API Gateway];: Triển khai với YARP, Ocelot hoặc Azure API
  Management
- #strong[Communication];: gRPC cho RPC hiệu suất cao, REST API cho
  tương tác web
- #strong[Event Messaging];: RabbitMQ, Azure Service Bus, Kafka cho giao
  tiếp bất đồng bộ

Ví dụ về kiến trúc e-commerce với microservices:

- Product Catalog Service
- Inventory Service
- Order Service
- Payment Service
- User Service
- Notification Service

Mỗi service có database riêng, API riêng và có thể được phát triển,
triển khai và mở rộng độc lập.

=== Domain-Driven Design (DDD)
<domain-driven-design-ddd>
DDD là phương pháp thiết kế phần mềm tập trung vào mô hình hóa miền
nghiệp vụ phức tạp, rất phù hợp với hệ thống lớn:

- #strong[Bounded Contexts];: Ranh giới rõ ràng trong mô hình domain
- #strong[Ubiquitous Language];: Ngôn ngữ chung giữa các chuyên gia
  nghiệp vụ và nhà phát triển
- #strong[Aggregates];: Nhóm các entities và value objects liên quan
- #strong[Domain Events];: Truyền thông tin về các sự kiện quan trọng
  trong domain

Ví dụ về triển khai DDD trong .NET Core:

```cs
// Domain Event
public class OrderPlacedDomainEvent : IDomainEvent
{
    public Guid OrderId { get; }
    public DateTime PlacedDate { get; }
    
    public OrderPlacedDomainEvent(Guid orderId, DateTime placedDate)
    {
        OrderId = orderId;
        PlacedDate = placedDate;
    }
}

// Aggregate Root
public class Order : Entity, IAggregateRoot
{
    public Guid Id { get; private set; }
    public OrderStatus Status { get; private set; }
    public CustomerId CustomerId { get; private set; }
    public Money TotalAmount { get; private set; }
    public Address ShippingAddress { get; private set; }
    public IReadOnlyCollection<OrderItem> Items => _items.AsReadOnly();
    
    private readonly List<OrderItem> _items = new List<OrderItem>();
    
    public static Order Create(CustomerId customerId, Address shippingAddress)
    {
        var order = new Order
        {
            Id = Guid.NewGuid(),
            CustomerId = customerId,
            ShippingAddress = shippingAddress,
            Status = OrderStatus.Draft,
            TotalAmount = Money.Zero(Currency.USD)
        };
        
        return order;
    }
    
    public void AddItem(ProductId productId, string productName, Money unitPrice, int quantity)
    {
        var existingItem = _items.FirstOrDefault(i => i.ProductId == productId);
        if (existingItem != null)
        {
            existingItem.UpdateQuantity(existingItem.Quantity + quantity);
        }
        else
        {
            var orderItem = new OrderItem(this.Id, productId, productName, unitPrice, quantity);
            _items.Add(orderItem);
        }
        
        RecalculateTotalAmount();
    }
    
    public void ConfirmOrder()
    {
        if (Status != OrderStatus.Draft)
            throw new OrderingDomainException("Cannot confirm order that is not in Draft status");
            
        if (!Items.Any())
            throw new OrderingDomainException("Cannot confirm order without items");
            
        Status = OrderStatus.Confirmed;
        
        AddDomainEvent(new OrderPlacedDomainEvent(Id, DateTime.UtcNow));
    }
    
    private void RecalculateTotalAmount()
    {
        TotalAmount = Money.Zero(Currency.USD);
        foreach (var item in _items)
        {
            TotalAmount += item.TotalPrice;
        }
    }
}
```

=== Event-Driven Architecture
<event-driven-architecture>
Hệ thống lớn thường sử dụng mẫu Event-Driven Architecture để giảm sự phụ
thuộc và tăng tính mở rộng:

- #strong[Event Sourcing];: Lưu trữ các thay đổi trạng thái dưới dạng
  chuỗi events
- #strong[CQRS (Command Query Responsibility Segregation)];: Tách riêng
  operations đọc và ghi
- #strong[Message Brokers];: RabbitMQ, Azure Service Bus hoặc Kafka để
  truyền events

.NET Core có các công cụ để triển khai event-driven architecture:

- MassTransit hoặc NServiceBus cho message handling
- EventStore hoặc Marten cho event sourcing
- MediatR cho CQRS và in-process messaging

=== Khả năng mở rộng và Resilience
<khả-năng-mở-rộng-và-resilience>
Các hệ thống lớn cần được thiết kế để xử lý tải cao và phục hồi sau lỗi:

- #strong[Horizontal Scaling];: Thêm nhiều instance thông qua load
  balancing
- #strong[Sharding];: Phân chia database theo keys nhất định
- #strong[Caching Strategies];: Redis distributed cache, in-memory
  caching
- #strong[Circuit Breaker Pattern];: Sử dụng Polly để ngăn lỗi cascade

```cs
// Cấu hình Polly cho resilience
services.AddHttpClient<ICatalogService, CatalogService>()
    .AddTransientHttpErrorPolicy(policy => policy.RetryAsync(3))
    .AddTransientHttpErrorPolicy(policy => policy.CircuitBreakerAsync(
        handledEventsAllowedBeforeBreaking: 5,
        durationOfBreak: TimeSpan.FromSeconds(30)
    ));
```

=== Bảo mật và Xác thực
<bảo-mật-và-xác-thực>
Bảo mật là yếu tố quan trọng trong hệ thống lớn:

- #strong[Identity Server];: Cung cấp giải pháp SSO và OAuth/OpenID
  Connect
- #strong[Authentication];: JWT, cookie-based, và multi-factor
  authentication
- #strong[Authorization];: Policy-based authorization, role-based access
  control
- #strong[Data Protection];: Mã hóa dữ liệu nhạy cảm

```cs
// Cấu hình JWT authentication
services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = Configuration["Jwt:Issuer"],
            ValidAudience = Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(Configuration["Jwt:Key"]))
        };
    });

// Cấu hình authorization policies
services.AddAuthorization(options =>
{
    options.AddPolicy("AdminOnly", policy => 
        policy.RequireRole("Administrator"));
        
    options.AddPolicy("OrderManagement", policy =>
        policy.RequireClaim("Permission", "Orders.Read", "Orders.Write"));
});
```

=== Giám sát và Diagnostics
<giám-sát-và-diagnostics>
Hệ thống lớn yêu cầu giám sát và phân tích toàn diện:

- #strong[Distributed Tracing];: Với OpenTelemetry và Jaeger/Zipkin
- #strong[Logging];: Sử dụng Serilog, NLog gửi đến Elasticsearch hoặc
  Application Insights
- #strong[Metrics];: Prometheus, Grafana để theo dõi hiệu suất
- #strong[Health Checks];: Kiểm tra trạng thái của các thành phần và
  dependencies

```cs
// Cấu hình OpenTelemetry
services.AddOpenTelemetryTracing(builder =>
{
    builder
        .AddAspNetCoreInstrumentation()
        .AddHttpClientInstrumentation()
        .AddEntityFrameworkCoreInstrumentation()
        .AddSource("MyCompany.MyService")
        .SetResourceBuilder(ResourceBuilder.CreateDefault()
            .AddService("MyService", "MyCompany", "1.0.0"))
        .AddJaegerExporter(options =>
        {
            options.AgentHost = Configuration["Jaeger:AgentHost"];
            options.AgentPort = int.Parse(Configuration["Jaeger:AgentPort"]);
        });
});

// Cấu hình Health Checks
services.AddHealthChecks()
    .AddDbContextCheck<OrderContext>("order-db")
    .AddRedis(Configuration.GetConnectionString("Redis"), name: "redis-cache")
    .AddRabbitMQ(Configuration.GetConnectionString("RabbitMQ"), name: "rabbitmq")
    .AddCheck<ExternalApiHealthCheck>("external-api", tags: new[] { "api" });
```

=== Triển khai và DevOps
<triển-khai-và-devops>
Quy trình triển khai hiệu quả là yếu tố quan trọng cho hệ thống lớn:

- #strong[Infrastructure as Code];: Terraform, Azure Resource Manager,
  CloudFormation
- #strong[CI/CD Pipelines];: Azure DevOps, GitHub Actions, Jenkins
- #strong[Blue-Green Deployment];: Giảm thiểu thời gian ngừng hoạt động
- #strong[Canary Releases];: Triển khai dần dần để phát hiện sớm vấn đề

Với GitHub Actions:

```yaml
name: Build and Deploy

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: '8.0.x'
        
    - name: Restore dependencies
      run: dotnet restore
      
    - name: Build
      run: dotnet build --no-restore --configuration Release
      
    - name: Test
      run: dotnet test --no-build --configuration Release
      
    - name: Publish
      run: dotnet publish --no-build --configuration Release
      
    - name: Build and push Docker image
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: myregistry.azurecr.io/myapp:${{ github.sha }}
        
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
    - name: Deploy to AKS
      uses: azure/k8s-deploy@v4
      with:
        namespace: production
        manifests: |
          kubernetes/deployment.yaml
          kubernetes/service.yaml
        images: myregistry.azurecr.io/myapp:${{ github.sha }}
```

=== Tổng kết
<tổng-kết>
Thiết kế hệ thống lớn với .NET Core yêu cầu kết hợp nhiều yếu tố:

- Kiến trúc phù hợp (microservices, layered, clean architecture)
- Phương pháp thiết kế domain-driven và event-driven
- Giải pháp mở rộng và resilience
- Bảo mật toàn diện
- Giám sát và diagnostics hiệu quả
- Quy trình triển khai tự động

.NET Core cung cấp một nền tảng mạnh mẽ và các công cụ phong phú để xây
dựng các hệ thống phức tạp, có khả năng mở rộng cao phục vụ hàng triệu
người dùng. Kết hợp với các thực hành phát triển và kiến trúc hiện đại,
nó cho phép xây dựng các hệ thống doanh nghiệp lớn, đáng tin cậy và có
khả năng phát triển.

