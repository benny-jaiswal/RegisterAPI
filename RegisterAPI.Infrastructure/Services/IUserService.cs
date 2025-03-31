using RegisterAPI.Infrastructure.Data.Dto;

namespace RegisterAPI.Infrastructure.Services
{
    public interface IUserService
    {
        Task<UserDto> Authenticate(string username, string password);
        List<string> GetUserRoles(int userId);
        Task<IEnumerable<UserDto>> GetAllUsersAsync();
        Task<bool> RegisterUserAsync(UserRegistrationDto userDto);
        Task<UserDto> GetUser();
    }

}
