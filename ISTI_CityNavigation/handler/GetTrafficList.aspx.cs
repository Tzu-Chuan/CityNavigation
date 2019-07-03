using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace ISTI_CityNavigation.WebPage.wHandler
{
    public partial class GetTrafficList : System.Web.UI.Page
    {
        Traffic_DB n_db = new Traffic_DB();
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 撈交通列表
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string Tra_CityNo = (Request["CityNo"] != null) ? Request["CityNo"].ToString().Trim() : "";
                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                if (com.VeriftyToken(token))
                {
                    n_db._Tra_CityNo = Tra_CityNo;
                    DataTable dt = n_db.getTrafficList();
                    string xmlstr = string.Empty;
                    xmlstr = DataTableToXml.ConvertDatatableToXML(dt, "dataList", "data_item");
                    xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + "</root>";
                    xDoc.LoadXml(xmlstr);
                }
                else
                {
                    xDoc = ExceptionUtil.GetTokenErrorMassageDocument();
                    Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
                    xDoc.Save(Response.Output);
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