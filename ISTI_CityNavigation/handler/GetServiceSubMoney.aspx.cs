using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Xml;

namespace ISTI_CityNavigation.handler
{
    public partial class GetServiceSubMoney : System.Web.UI.Page
    {
        ServiceSubMoney_DB ssm_db = new ServiceSubMoney_DB();
        Common com = new Common();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢補助經費服務主軸分析
            ///說    明:
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string xmlstr = string.Empty;

                DataTable dt = ssm_db.getSubsidyServiceAnalyze();
                string token = (string.IsNullOrEmpty(Request["Token"])) ? "" : Request["Token"].ToString().Trim();
                if (com.VeriftyToken(token))
                {
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