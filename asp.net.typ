== Lập trình web với ASP.NET
<lập-trình-web-với-asp.net>
=== Kiến Trúc Ứng Dụng
<kiến-trúc-ứng-dụng>
==== Tổ chức dự án theo mô hình Clean Architecture
<tổ-chức-dự-án-theo-mô-hình-clean-architecture>
Nên áp dụng mô hình kiến trúc phân lớp rõ ràng với các lớp: -
Presentation Layer (API/UI) - Application Layer (Services) - Domain
Layer (Entities, Interfaces) - Infrastructure Layer (Repositories,
External Services)

```cs
// Domain Layer - Entity
public class Customer
{
    public int Id { get; set; }
    public string Name { get; set; }
}

// Application Layer - Service
public class CustomerService : ICustomerService
{
    private readonly ICustomerRepository _repository;
    
    public CustomerService(ICustomerRepository repository)
    {
        _repository = repository;
    }
}
```

==== Sử dụng Dependency Injection
<sử-dụng-dependency-injection>
Đăng ký các dịch vụ trong container DI của ASP.NET Core:

```cs
// Startup.cs hoặc Program.cs
services.AddScoped<ICustomerRepository, CustomerRepository>();
services.AddScoped<ICustomerService, CustomerService>();
```

=== API Development
<api-development>
==== Sử dụng RESTful API Conventions
<sử-dụng-restful-api-conventions>
Tuân thủ các quy ước REST cho các endpoint API:

```cs
// Controller
[ApiController]
[Route("api/[controller]")]
public class CustomersController : ControllerBase
{
    [HttpGet]
    public async Task<ActionResult<IEnumerable<CustomerDto>>> GetAll() { }
    
    [HttpGet("{id}")]
    public async Task<ActionResult<CustomerDto>> GetById(int id) { }
    
    [HttpPost]
    public async Task<ActionResult<CustomerDto>> Create(CreateCustomerDto dto) { }
}
```

==== Xác thực và Phân quyền
<xác-thực-và-phân-quyền>
Sử dụng JWT hoặc Identity để xác thực và phân quyền:

```cs
// Cấu hình xác thực
services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options => { /* Cấu hình */ });

// Áp dụng phân quyền trong controller
[Authorize(Roles = "Admin")]
[HttpDelete("{id}")]
public async Task<IActionResult> Delete(int id) { }
```

=== Xử Lý Dữ Liệu
<xử-lý-dữ-liệu>
==== Sử dụng Entity Framework Core hiệu quả
<sử-dụng-entity-framework-core-hiệu-quả>
Tối ưu hóa truy vấn và theo dõi thay đổi:

```cs
// Truy vấn chỉ đọc
var customers = await _context.Customers
    .AsNoTracking()
    .Where(c => c.IsActive)
    .ToListAsync();

// Eager loading
var orders = await _context.Orders
    .Include(o => o.Customer)
    .Include(o => o.OrderItems)
        .ThenInclude(i => i.Product)
    .ToListAsync();
```

==== Áp dụng Repository Pattern
<áp-dụng-repository-pattern>
Tách biệt logic truy cập dữ liệu:

```cs
public class CustomerRepository : ICustomerRepository
{
    private readonly AppDbContext _context;
    
    public CustomerRepository(AppDbContext context)
    {
        _context = context;
    }
    
    public async Task<Customer> GetByIdAsync(int id)
    {
        return await _context.Customers.FindAsync(id);
    }
}
```

=== Xử Lý Lỗi và Logging
<xử-lý-lỗi-và-logging>
==== Middleware xử lý lỗi toàn cục
<middleware-xử-lý-lỗi-toàn-cục>
Cấu hình middleware để xử lý ngoại lệ:

```cs
// Middleware xử lý ngoại lệ
app.UseExceptionHandler(builder =>
{
    builder.Run(async context =>
    {
        context.Response.StatusCode = StatusCodes.Status500InternalServerError;
        // Xử lý lỗi...
    });
});
```

==== Logging hiệu quả
<logging-hiệu-quả>
Sử dụng ILogger và cấu hình các sink phù hợp:

```cs
// Cấu hình logging
services.AddLogging(builder =>
{
    builder.AddConsole();
    builder.AddDebug();
    builder.AddSerilog();
});

// Sử dụng trong service
public class ProductService
{
    private readonly ILogger<ProductService> _logger;
    
    public ProductService(ILogger<ProductService> logger)
    {
        _logger = logger;
    }
    
    public void ProcessOrder(Order order)
    {
        _logger.LogInformation("Đang xử lý đơn hàng {OrderId}", order.Id);
    }
}
```

=== Bảo Mật
<bảo-mật>
==== Phòng chống XSS
<phòng-chống-xss>
Sử dụng các biện pháp bảo vệ chống tấn công XSS:

```cs
// Cấu hình CSP
app.Use(async (context, next) =>
{
    context.Response.Headers.Add("Content-Security-Policy", 
        "default-src 'self'; script-src 'self' https://trusted-cdn.com");
    await next();
});
```

==== Bảo vệ dữ liệu nhạy cảm
<bảo-vệ-dữ-liệu-nhạy-cảm>
Mã hóa dữ liệu nhạy cảm và sử dụng Data Protection API:

```cs
// Cấu hình Data Protection
services.AddDataProtection()
    .PersistKeysToFileSystem(new DirectoryInfo(@"C:\keys\"))
    .SetDefaultKeyLifetime(TimeSpan.FromDays(14));
```

=== Hiệu Suất
<hiệu-suất>
==== Caching
<caching>
Sử dụng các cơ chế cache khác nhau:

```cs
// Memory Cache
services.AddMemoryCache();

// Distributed Cache với Redis
services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = "localhost:6379";
});

// Sử dụng trong controller
[ResponseCache(Duration = 60)]
[HttpGet("products")]
public async Task<IActionResult> GetProducts() { }
```

==== Compression và Response Buffering
<compression-và-response-buffering>
Giảm kích thước phản hồi:

```cs
// Cấu hình nén
services.AddResponseCompression(options =>
{
    options.EnableForHttps = true;
    options.Providers.Add<GzipCompressionProvider>();
});
```

=== Testing
<testing>
==== Unit Testing
<unit-testing>
Viết unit test cho các service và controller:

```cs
[Fact]
public async Task GetById_ExistingId_ReturnsCustomer()
{
    // Arrange
    var mockRepo = new Mock<ICustomerRepository>();
    mockRepo.Setup(repo => repo.GetByIdAsync(1))
        .ReturnsAsync(new Customer { Id = 1, Name = "Test" });
    
    var service = new CustomerService(mockRepo.Object);
    
    // Act
    var result = await service.GetByIdAsync(1);
    
    // Assert
    Assert.NotNull(result);
    Assert.Equal(1, result.Id);
}
```

==== Integration Testing
<integration-testing>
Sử dụng TestServer để kiểm tra toàn bộ pipeline:

```cs
public class ApiIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;
    
    public ApiIntegrationTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }
    
    [Fact]
    public async Task GetCustomers_ReturnsSuccessStatusCode()
    {
        // Arrange
        var client = _factory.CreateClient();
        
        // Act
        var response = await client.GetAsync("/api/customers");
        
        // Assert
        response.EnsureSuccessStatusCode();
    }
}
```

=== Triển Khai và DevOps
<triển-khai-và-devops>
==== Cấu hình theo môi trường
<cấu-hình-theo-môi-trường>
Sử dụng cấu hình phù hợp với từng môi trường:

```cs
// Cấu hình theo môi trường
var builder = WebApplication.CreateBuilder(args);
builder.Configuration
    .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
    .AddJsonFile($"appsettings.{builder.Environment.EnvironmentName}.json", optional: true)
    .AddEnvironmentVariables();
```

==== Health Checks
<health-checks>
Thêm endpoint kiểm tra sức khỏe ứng dụng:

```cs
// Cấu hình health checks
services.AddHealthChecks()
    .AddDbContextCheck<AppDbContext>()
    .AddCheck("Elasticsearch", () => HealthCheckResult.Healthy());

// Map health check endpoints
app.MapHealthChecks("/health");
```
