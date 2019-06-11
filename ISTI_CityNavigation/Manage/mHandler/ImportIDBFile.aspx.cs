using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.SS.UserModel; //-- v.1.2.4起 新增的。
using NPOI.XSSF.UserModel; //-- XSSF 用來產生Excel 2007檔案（.xlsx）
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class ImportIDBFile : System.Web.UI.Page
    {
        CitySubMoney_DB csm_db = new CitySubMoney_DB();
        BudgetExecution_DB be_db = new BudgetExecution_DB();
        ServiceSubMoney_DB ssm_db = new ServiceSubMoney_DB();
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 匯入工業局資料
            ///說    明:
            /// 
            ///-----------------------------------------------------

            /// Transaction
            SqlConnection oConn = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"].ToString());
            oConn.Open();
            SqlCommand oCmd = new SqlCommand();
            oCmd.Connection = oConn;
            SqlTransaction myTrans = oConn.BeginTransaction();
            oCmd.Transaction = myTrans;
            try
            {
                HttpFileCollection uploadFiles = Request.Files;//檔案集合
                HttpPostedFile aFile = uploadFiles[0];

                IWorkbook workbook = new XSSFWorkbook(aFile.InputStream);

                DoCitySubMoney(workbook, oConn, myTrans);
                DoBudgetExecution(workbook, oConn, myTrans);
                DoServiceSubMoney(workbook, oConn, myTrans);

                myTrans.Commit();
                oCmd.Connection.Close();
                oConn.Close();
                Response.Write("<script type='text/JavaScript'>parent.feedbackFun('上傳成功');</script>");
            }
            catch (Exception ex)
            {
                myTrans.Rollback();
                Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + ex.Message.Replace("'", "") + "');</script>");
            }
        }

        #region 執行各Sheet匯入

        #region 預計經費執行情形
        private void DoBudgetExecution(IWorkbook workbook, SqlConnection oConn, SqlTransaction myTrans)
        {
            ISheet sheet = workbook.GetSheetAt(0);
            /// 抓最大版次+1
            int maxV = be_db.getMaxVersion() + 1;
            DataTable dt = CreateBudgetExecution();
            /// 資料從第3筆開始 最後一筆合計不進資料庫
            for (int i = 2; i < 5; i++)
            {
                DataRow row = dt.NewRow();
                row["B_Commission"] = sheet.GetRow(2).GetCell(i).ToString().Trim();
                row["B_Subsidy"] = sheet.GetRow(3).GetCell(i).ToString().Trim();
                row["B_Sub01"] = sheet.GetRow(5).GetCell(i).ToString().Trim();
                row["B_Sub02"] = sheet.GetRow(6).GetCell(i).ToString().Trim();
                row["B_Sub03"] = sheet.GetRow(7).GetCell(i).ToString().Trim();
                row["B_RemainBudget"] = sheet.GetRow(8).GetCell(i).ToString().Trim();
                row["B_Rate"] = sheet.GetRow(9).GetCell(i).ToString().Trim();
                row["B_CreateId"] = LogInfo.mGuid;
                row["B_CreateName"] = LogInfo.name;
                row["B_Version"] = maxV;
                row["B_Status"] = "A";
                dt.Rows.Add(row);
            }
            if (dt.Rows.Count > 0)
            {
                be_db.BeforeBulkCopy(oConn, myTrans); // update old data set status='D'
                be_db.DoBulkCopy(dt, myTrans);
            }
        }
        #endregion

        #region 補助經費縣市分析
        private void DoCitySubMoney(IWorkbook workbook, SqlConnection oConn, SqlTransaction myTrans)
        {
            ISheet sheet = workbook.GetSheetAt(1);
            /// 抓最大版次+1
            int maxV = csm_db.getMaxVersion() + 1;
            DataTable dt = CreateCitySubMoney();
            /// 資料從第3筆開始 最後一筆合計不進資料庫
            for (int i = 2; i < sheet.PhysicalNumberOfRows - 1; i++)
            {
                DataRow row = dt.NewRow();
                row["C_City"] = sheet.GetRow(i).GetCell(0).ToString().Trim();
                row["C_PlanCount_NotAll"] = sheet.GetRow(i).GetCell(1).ToString().Trim();
                row["C_SubMoney_NotAll"] = sheet.GetRow(i).GetCell(2).ToString().Trim();
                row["C_PlanMoney_NotAll"] = sheet.GetRow(i).GetCell(3).ToString().Trim();
                row["C_AssignSubMoney"] = sheet.GetRow(i).GetCell(4).ToString().Trim();
                row["C_AssignTotalMoney"] = sheet.GetRow(i).GetCell(5).ToString().Trim();
                row["C_CitySubMoneyRatio_NotAll"] = sheet.GetRow(i).GetCell(6).ToString().Trim();
                row["C_CityTotalMoneyRatio_NotAll"] = sheet.GetRow(i).GetCell(7).ToString().Trim();
                row["C_PlanCount"] = sheet.GetRow(i).GetCell(8).ToString().Trim();
                row["C_SubMoney"] = sheet.GetRow(i).GetCell(9).ToString().Trim();
                row["C_PlanMoney"] = sheet.GetRow(i).GetCell(10).ToString().Trim();
                row["C_CitySubMoneyRatio"] = sheet.GetRow(i).GetCell(11).ToString().Trim();
                row["C_CityTotalMoneyRatio"] = sheet.GetRow(i).GetCell(12).ToString().Trim();
                row["C_CreateId"] = LogInfo.mGuid;
                row["C_CreateName"] = LogInfo.name;
                row["C_Version"] = maxV;
                row["C_Status"] = "A";
                dt.Rows.Add(row);
            }
            if (dt.Rows.Count > 0)
            {
                csm_db.BeforeBulkCopy(oConn, myTrans); // update old data set status='D'
                csm_db.DoBulkCopy(dt, myTrans);
            }
        }
        #endregion

        #region 補助經費服務主軸分析
        private void DoServiceSubMoney(IWorkbook workbook, SqlConnection oConn, SqlTransaction myTrans)
        {
            ISheet sheet = workbook.GetSheetAt(2);
            /// 抓最大版次+1
            int maxV = ssm_db.getMaxVersion() + 1;
            DataTable dt = CreateServiceSubMoney();
            /// 資料從第3筆開始 最後一筆合計不進資料庫
            for (int i = 2; i < sheet.PhysicalNumberOfRows; i++)
            {
                DataRow row = dt.NewRow();
                row["S_Type"] = sheet.GetRow(i).GetCell(0).ToString().Trim();
                row["S_PlanCount"] = sheet.GetRow(i).GetCell(1).ToString().Trim();
                row["S_Subsidy"] = sheet.GetRow(i).GetCell(2).ToString().Trim();
                row["S_TotalMoney"] = sheet.GetRow(i).GetCell(3).ToString().Trim();
                row["S_SubsidyRatio"] = sheet.GetRow(i).GetCell(4).ToString().Trim();
                row["S_TotalMoneyRatio"] = sheet.GetRow(i).GetCell(5).ToString().Trim();
                row["S_CreateId"] = LogInfo.mGuid;
                row["S_CreateName"] = LogInfo.name;
                row["S_Version"] = maxV;
                row["S_Status"] = "A";
                dt.Rows.Add(row);
            }
            if (dt.Rows.Count > 0)
            {
                ssm_db.BeforeBulkCopy(oConn, myTrans); // update old data set status='D'
                ssm_db.DoBulkCopy(dt, myTrans);
            }
        }
        #endregion

        #endregion

        #region 建立DataTable

        #region CitySubMoney
        private DataTable CreateCitySubMoney()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("C_City", typeof(string));
            dt.Columns.Add("C_PlanCount_NotAll", typeof(string));
            dt.Columns.Add("C_SubMoney_NotAll", typeof(string));
            dt.Columns.Add("C_PlanMoney_NotAll", typeof(string));
            dt.Columns.Add("C_AssignSubMoney", typeof(string));
            dt.Columns.Add("C_AssignTotalMoney", typeof(string));
            dt.Columns.Add("C_CitySubMoneyRatio_NotAll", typeof(string));
            dt.Columns.Add("C_CityTotalMoneyRatio_NotAll", typeof(string));
            dt.Columns.Add("C_PlanCount", typeof(string));
            dt.Columns.Add("C_SubMoney", typeof(string));
            dt.Columns.Add("C_PlanMoney", typeof(string));
            dt.Columns.Add("C_CitySubMoneyRatio", typeof(string));
            dt.Columns.Add("C_CityTotalMoneyRatio", typeof(string));
            dt.Columns.Add("C_CreateId", typeof(string));
            dt.Columns.Add("C_CreateName", typeof(string));
            dt.Columns.Add("C_Version", typeof(Int32));
            dt.Columns.Add("C_Status", typeof(string));
            return dt;
        }
        #endregion

        #region BudgetExecution
        private DataTable CreateBudgetExecution()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("B_ID", typeof(string));
            dt.Columns.Add("B_Commission", typeof(string));
            dt.Columns.Add("B_Subsidy", typeof(string));
            dt.Columns.Add("B_Sub01", typeof(string));
            dt.Columns.Add("B_Sub02", typeof(string));
            dt.Columns.Add("B_Sub03", typeof(string));
            dt.Columns.Add("B_RemainBudget", typeof(string));
            dt.Columns.Add("B_Rate", typeof(string));
            dt.Columns.Add("B_CreateId", typeof(string));
            dt.Columns.Add("B_CreateName", typeof(string));
            dt.Columns.Add("B_Version", typeof(Int32));
            dt.Columns.Add("B_Status", typeof(string));
            return dt;
        }
        #endregion

        #region ServiceSubMoney
        private DataTable CreateServiceSubMoney()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("S_ID", typeof(string));
            dt.Columns.Add("S_Type", typeof(string));
            dt.Columns.Add("S_PlanCount", typeof(string));
            dt.Columns.Add("S_Subsidy", typeof(string));
            dt.Columns.Add("S_TotalMoney", typeof(string));
            dt.Columns.Add("S_SubsidyRatio", typeof(string));
            dt.Columns.Add("S_TotalMoneyRatio", typeof(string));
            dt.Columns.Add("S_CreateId", typeof(string));
            dt.Columns.Add("S_CreateName", typeof(string));
            dt.Columns.Add("S_Version", typeof(Int32));
            dt.Columns.Add("S_Status", typeof(string));
            return dt;
        }
        #endregion

        #endregion
    }
}