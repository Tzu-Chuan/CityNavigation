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
    public partial class GetBudgetExecution : System.Web.UI.Page
    {
        BudgetExecution_DB be_db = new BudgetExecution_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 查詢預計經費執行情形
            ///說    明:
            ///-----------------------------------------------------
            XmlDocument xDoc = new XmlDocument();
            try
            {
                string xmlstr = string.Empty;
                string xmlstr2 = string.Empty;

                DataSet ds = be_db.getBudgetExecution();
                if (ds.Tables[0].Rows.Count > 0)
                    xmlstr = GenXml(ds.Tables[0]);
                xmlstr2 = "<total>" + ds.Tables[1].Rows[0]["total"].ToString() + "</total>";
                xmlstr = "<?xml version='1.0' encoding='utf-8'?><root>" + xmlstr + xmlstr2 + "</root>";
                xDoc.LoadXml(xmlstr);
            }
            catch (Exception ex)
            {
                xDoc = ExceptionUtil.GetExceptionDocument(ex);
            }
            Response.ContentType = System.Net.Mime.MediaTypeNames.Text.Xml;
            xDoc.Save(Response.Output);
        }

        private string GenXml(DataTable dt)
        {
            string rVal = string.Empty;
            XmlDocument doc = new XmlDocument();
            /// 根節點
            XmlElement dataList = doc.CreateElement("dataList");
            doc.AppendChild(dataList);
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                /// Node
                XmlElement dataItem = doc.CreateElement("data_item");
                /// Element Value
                XmlElement Str1 = doc.CreateElement("Str1");
                Str1.InnerText = VerificationString(dt.Rows[0][i].ToString());
                dataItem.AppendChild(Str1);
                XmlElement Str2 = doc.CreateElement("Str2");
                Str2.InnerText = VerificationString(dt.Rows[1][i].ToString());
                dataItem.AppendChild(Str2);
                XmlElement Str3 = doc.CreateElement("Str3");
                Str3.InnerText = VerificationString(dt.Rows[2][i].ToString());
                dataItem.AppendChild(Str3);
                dataList.AppendChild(dataItem);
            }
            rVal = doc.OuterXml.ToString();
            return rVal;
        }

        private string VerificationString(string str)
        {
            string rVal = string.Empty;
            if (string.IsNullOrEmpty(str))
                rVal = " ";
            else
                rVal = str;
            return rVal;
        }
    }
}