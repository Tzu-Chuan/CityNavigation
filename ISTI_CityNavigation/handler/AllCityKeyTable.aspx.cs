using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace ISTI_CityNavigation.handler
{
    public partial class AllCityKeyTable : System.Web.UI.Page
    {
        KeyTable_DB n_db = new KeyTable_DB();
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string K_Code = (Request["K_Code"] != null) ? Request["K_Code"].ToString().Trim() : "";
                string K_ItemNo = (Request["K_ItemNo"] != null) ? Request["K_ItemNo"].ToString().Trim() : "";
                string token = (string.IsNullOrEmpty(Request.Form["Token"])) ? "" : Request.Form["Token"].ToString().Trim();

                DataTable dt = new DataTable();
                if (Common.VeriftyToken(token))
                {
                    n_db._K_Code = K_Code;
                    n_db._K_ItemNo = K_ItemNo;
                    dt = n_db.getKeyWord();
                    string xmlstr = string.Empty;
                    xmlstr = DataTableToXml.ConvertDatatableToXML(dt, "dataList", "data_item");
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                {
                    xDoc = ExceptionUtil.GetErrorMassageDocument("TokenFail");
                }
            }
            catch (Exception ex)
            {
                xDoc = ExceptionUtil.GetExceptionDocument(ex);
            }

            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
            xDoc.Save(Response.Output);
        }
    }
}