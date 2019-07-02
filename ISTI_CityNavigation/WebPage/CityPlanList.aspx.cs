using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ISTI_CityNavigation.WebPage
{
    public partial class CityPlanList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            GenToken();
        }
        private void GenToken()
        {
            string token = CreateToken();
            SaveTokenToClient(token);
            SaveTokenToServer(token);
        }

        private string CreateToken()
        {
            string tokenKey = this.Session.SessionID + DateTime.Now.Ticks.ToString();
            System.Security.Cryptography.MD5CryptoServiceProvider md5 =
                    new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] b = md5.ComputeHash(System.Text.Encoding.UTF8.GetBytes(tokenKey));
            return BitConverter.ToString(b).Replace("-", string.Empty);
        }

        private void SaveTokenToClient(string pToken)
        {
            hfToken.Value = pToken;
        }

        private void SaveTokenToServer(string pToken)
        {
            Session["Token"] = pToken;
        }
    }
}