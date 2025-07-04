= Best pratices

== Với .NET

<best-practices>
=== Tổ Chức Mã Nguồn
<tổ-chức-mã-nguồn>
==== Kiến Trúc Ứng Dụng
<kiến-trúc-ứng-dụng>
Nên áp dụng kiến trúc phân lớp rõ ràng hoặc kiến trúc Clean
Architecture:

```cs
// Tổ chức theo lớp
namespace MyApp.Core {}
namespace MyApp.Infrastructure {}
namespace MyApp.API {}
```

==== Nguyên Tắc SOLID
<nguyên-tắc-solid>
Tuân thủ các nguyên tắc SOLID để tạo mã nguồn linh hoạt và dễ bảo trì:

```cs
// Nguyên tắc trách nhiệm đơn lẻ (SRP)
public class UserService
{
    public void RegisterUser() { /* Một trách nhiệm duy nhất */ }
}
```

=== Quản Lý Phụ Thuộc
<quản-lý-phụ-thuộc>
==== Dependency Injection
<dependency-injection>
Sử dụng DI tích hợp sẵn trong .NET:

```cs
// Đăng ký dịch vụ
services.AddScoped<IUserRepository, UserRepository>();

// Tiêm phụ thuộc qua constructor
public class UserController
{
    private readonly IUserRepository _userRepository;
    
    public UserController(IUserRepository userRepository)
    {
        _userRepository = userRepository;
    }
}
```

=== Xử Lý Dữ Liệu
<xử-lý-dữ-liệu>
==== Entity Framework Core
<entity-framework-core>
Thực hành tốt với ORM:

```cs
// Sử dụng AsNoTracking() cho truy vấn chỉ đọc
var users = await _context.Users.AsNoTracking().ToListAsync();

// Sử dụng migrations để quản lý schema
dotnet ef migrations add InitialCreate
```

==== Truy vấn hiệu quả
<truy-vấn-hiệu-quả>
```cs
// Sử dụng phương pháp truy vấn phù hợp
var activeUsers = await _context.Users
    .Where(u => u.IsActive)
    .Select(u => new { u.Id, u.Name })
    .ToListAsync();
```

=== Xử Lý Lỗi và Ghi Log
<xử-lý-lỗi-và-ghi-log>
==== Xử lý ngoại lệ
<xử-lý-ngoại-lệ>
```cs
try
{
    await _userService.RegisterUser(model);
}
catch (ValidationException ex)
{
    _logger.LogWarning(ex, "Lỗi xác thực");
    return BadRequest(ex.Message);
}
catch (Exception ex)
{
    _logger.LogError(ex, "Lỗi không xác định");
    return StatusCode(500, "Đã xảy ra lỗi hệ thống");
}
```

==== Ghi log hiệu quả
<ghi-log-hiệu-quả>
```cs
// Sử dụng các cấp độ log phù hợp
_logger.LogDebug("Bắt đầu xử lý {RequestId}", requestId);
_logger.LogInformation("Người dùng {UserId} đã đăng nhập", userId);
_logger.LogError(ex, "Lỗi khi xử lý thanh toán cho đơn hàng {OrderId}", orderId);
```

=== Bất Đồng Bộ
<bất-đồng-bộ>
==== Sử dụng async/await
<sử-dụng-asyncawait>
```cs
// Luôn sử dụng phiên bản async của các phương thức
public async Task<IActionResult> GetUserAsync(int id)
{
    var user = await _userRepository.GetByIdAsync(id);
    return Ok(user);
}
```

==== Tránh anti-patterns
<tránh-anti-patterns>
```cs
// KHÔNG sử dụng .Result hoặc .Wait()
// Thay vì:
var result = task.Result; // Có thể gây deadlock

// Hãy sử dụng:
var result = await task;
```

=== Bảo Mật
<bảo-mật>
==== Xác thực và Phân quyền
<xác-thực-và-phân-quyền>
```cs
// Sử dụng Identity và JWT
services.AddIdentity<ApplicationUser, IdentityRole>()
    .AddEntityFrameworkStores<AppDbContext>();
    
// Phân quyền với Attribute
[Authorize(Roles = "Admin")]
public async Task<IActionResult> AdminAction() { /* ... */ }
```

==== Phòng chống lỗi bảo mật
<phòng-chống-lỗi-bảo-mật>
```cs
// Sử dụng thư viện chuyên dụng cho mã hóa
var hashedPassword = passwordHasher.HashPassword(user, password);

// Bảo vệ khỏi tấn công SQL Injection bằng parameters
var users = await _context.Users.Where(u => u.Username == username).ToListAsync();
```

=== Hiệu Suất
<hiệu-suất>
==== Tối ưu bộ nhớ
<tối-ưu-bộ-nhớ>
```cs
// Sử dụng ArrayPool cho mảng lớn
using (var buffer = ArrayPool<byte>.Shared.Rent(1024))
{
    // Xử lý dữ liệu
    ArrayPool<byte>.Shared.Return(buffer);
}
```

==== Parallel và TPL
<parallel-và-tpl>
```cs
// Xử lý song song với PLINQ
var result = collection.AsParallel()
    .Where(item => SomeExpensiveOperation(item))
    .ToList();
```

=== Kiểm Thử
<kiểm-thử>
==== Unit Test
<unit-test>
```cs
[Fact]
public async Task GivenValidUser_WhenRegister_ThenSucceeds()
{
    // Arrange
    var mockRepo = new Mock<IUserRepository>();
    var service = new UserService(mockRepo.Object);
    
    // Act
    var result = await service.RegisterUser(validUser);
    
    // Assert
    Assert.True(result.IsSuccess);
}
```

==== Test Integration
<test-integration>
```cs
// Sử dụng TestServer
var factory = new WebApplicationFactory<Program>()
    .WithWebHostBuilder(builder => {
        builder.ConfigureServices(services => {
            // Cấu hình dịch vụ cho testing
        });
    });
```

=== Triển Khai và DevOps
<triển-khai-và-devops>
==== Containerization
<containerization>
```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "MyApp.dll"]
```

==== CI/CD
<cicd>
```yaml
# Ví dụ GitHub Actions
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: 7.0.x
```

=== Hiệu Năng và Giám Sát
<hiệu-năng-và-giám-sát>
==== Giám sát
<giám-sát>
```cs
// Sử dụng Application Insights
services.AddApplicationInsightsTelemetry();

// Thêm Health Checks
services.AddHealthChecks()
    .AddDbContextCheck<ApplicationDbContext>();
```

=== Phương Pháp Luồng Dữ Liệu
<phương-pháp-luồng-dữ-liệu>
==== Sử dụng CQRS
<sử-dụng-cqrs>
```cs
// Command
public record CreateUserCommand(string Name, string Email) : IRequest<Result>;

// Handler
public class CreateUserHandler : IRequestHandler<CreateUserCommand, Result>
{
    public async Task<Result> Handle(CreateUserCommand command, CancellationToken token)
    {
        // Xử lý logic
    }
}
```

==== Xử lý đồng thời
<xử-lý-đồng-thời>
```cs
// Sử dụng Channels cho luồng dữ liệu đồng thời
var channel = Channel.CreateUnbounded<WorkItem>();
await channel.Writer.WriteAsync(new WorkItem());

// Xử lý
await foreach (var item in channel.Reader.ReadAllAsync())
{
    // Xử lý công việc
}
```

#include "asp.net.typ"
