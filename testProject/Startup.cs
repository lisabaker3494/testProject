using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(testProject.Startup))]
namespace testProject
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
