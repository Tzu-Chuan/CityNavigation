using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.SS.UserModel;//-- v.1.2.4起 新增的。
using NPOI.XSSF.UserModel;//-- XSSF 用來產生Excel 2007檔案（.xlsx）
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class ImportEducation : System.Web.UI.Page
    {
        Education_DB EN_DB = new Education_DB();
        //建立共用參數
        string strErrorMsg = "";
        int strMaxVersion = 0;
        string chkYear = "";
        DateTime dtNow = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
        {
            //讀取Token值
            string token = (string.IsNullOrEmpty(Request.Form["mToken"])) ? "" : Request.Form["mToken"].ToString().Trim();
            if (VeriftyToken(token))
            {
                //建立共用connection & transaction
                SqlConnection oConn = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"].ToString());
                oConn.Open();
                SqlCommand oCmd = new SqlCommand();
                oCmd.Connection = oConn;
                SqlTransaction myTrans = oConn.BeginTransaction();
                oCmd.Transaction = myTrans;

                //建立DataTable Bulk Copy用
                DataTable dt = new DataTable();
                dt.Columns.Add("Edu_CityNo", typeof(string));
                dt.Columns.Add("Edu_CityName", typeof(string));
                dt.Columns.Add("Edu_15upJSDownRateYear", typeof(string));
                dt.Columns.Add("Edu_15upJSDownRate", typeof(string));
                dt.Columns.Add("Edu_15upHSRateYear", typeof(string));
                dt.Columns.Add("Edu_15upHSRate", typeof(string));
                dt.Columns.Add("Edu_15upUSUpRateYear", typeof(string));
                dt.Columns.Add("Edu_15upUSUpRate", typeof(string));
                dt.Columns.Add("Edu_ESStudentDropOutRateYear", typeof(string));
                dt.Columns.Add("Edu_ESStudentDropOutRate", typeof(string));
                dt.Columns.Add("Edu_JSStudentDropOutRateYear", typeof(string));
                dt.Columns.Add("Edu_JSStudentDropOutRate", typeof(string));
                dt.Columns.Add("Edu_ESStudentsYear", typeof(string));
                dt.Columns.Add("Edu_ESStudents", typeof(string));
                dt.Columns.Add("Edu_JSStudentsYear", typeof(string));
                dt.Columns.Add("Edu_JSStudents", typeof(string));
                dt.Columns.Add("Edu_HSStudentsYear", typeof(string));
                dt.Columns.Add("Edu_HSStudents", typeof(string));
                dt.Columns.Add("Edu_ESToHSIndigenousYear", typeof(string));
                dt.Columns.Add("Edu_ESToHSIdigenous", typeof(string));
                dt.Columns.Add("Edu_ESToHSIndigenousRateYear", typeof(string));
                dt.Columns.Add("Edu_ESToHSIndigenousRate", typeof(string));
                dt.Columns.Add("Edu_ESJSNewInhabitantsYear", typeof(string));
                dt.Columns.Add("Edu_ESJSNewInhabitants", typeof(string));
                dt.Columns.Add("Edu_ESJSNewInhabitantsRateYear", typeof(string));
                dt.Columns.Add("Edu_ESToJSNewInhabitantsRate", typeof(string));
                dt.Columns.Add("Edu_ESJSTeachersYear", typeof(string));
                dt.Columns.Add("Edu_ESJSTeachers", typeof(string));
                dt.Columns.Add("Edu_ESJSTeachersOfStudentRateYear", typeof(string));
                dt.Columns.Add("Edu_ESJSTeachersOfStudentRate", typeof(string));
                dt.Columns.Add("Edu_BudgetYear", typeof(string));
                dt.Columns.Add("Edu_Budget", typeof(string));
                dt.Columns.Add("Edu_BudgetUpRateYearDesc", typeof(string));
                dt.Columns.Add("Edu_BudgetUpRate", typeof(string));
                dt.Columns.Add("Edu_ESToHSAvgBudgetYear", typeof(string));
                dt.Columns.Add("Edu_ESToHSAvgBudget", typeof(string));
                dt.Columns.Add("Edu_ESJSPCNumYear", typeof(string));
                dt.Columns.Add("Edu_ESJSPCNum", typeof(string));
                dt.Columns.Add("Edu_ESJSAvgPCNumYear", typeof(string));
                dt.Columns.Add("Edu_ESJSAvgPCNum", typeof(string));
                dt.Columns.Add("Edu_CreateDate", typeof(DateTime));
                dt.Columns.Add("Edu_CreateID", typeof(string));
                dt.Columns.Add("Edu_CreateName", typeof(string));
                dt.Columns.Add("Edu_Status", typeof(string));
                dt.Columns.Add("Edu_Version", typeof(int));

                try
                {
                    HttpFileCollection uploadFiles = Request.Files;//檔案集合
                    HttpPostedFile aFile = uploadFiles[0];
                    //判斷有沒有檔案
                    if (uploadFiles.Count < 1 || aFile.FileName == "")
                    {
                        throw new Exception("請選擇檔案");
                    }

                    //有檔案繼續往下做
                    if (uploadFiles.Count > 0)
                    {
                        string extension = (System.IO.Path.GetExtension(aFile.FileName) == "") ? "" : System.IO.Path.GetExtension(aFile.FileName);
                        if (extension != ".xls" && extension != ".xlsx")
                        {
                            throw new Exception("請選擇xls或xlsx檔案上傳");
                        }

                        IWorkbook workbook;// = new HSSFWorkbook();//创建Workbook对象
                        workbook = new XSSFWorkbook(aFile.InputStream);

                        ISheet sheet = workbook.GetSheetAt(0);//當前sheet

                        //簡易判斷這份Excel是不是教育的Excel
                        int cellsCount = sheet.GetRow(0).Cells.Count;
                        //1.判斷表頭欄位數
                        if (cellsCount != 20)
                        {
                            throw new Exception("請檢查是否為教育的匯入檔案");
                        }
                        //2.檢查欄位名稱
                        if (sheet.GetRow(0).GetCell(1).ToString().Trim() != "15歲以上民間人口之教育程度結構-國中及以下" || sheet.GetRow(0).GetCell(2).ToString().Trim() != "15歲以上民間人口之教育程度結構-高中(職)")
                        {
                            throw new Exception("請檢查是否為教育的匯入檔案");
                        }

                        //取得當前最大版次 (+1變成現在版次)
                        strMaxVersion = EN_DB.getMaxVersin() + 1;

                        //取得代碼檔
                        CodeTable_DB code_db = new CodeTable_DB();
                        DataTable dtCode = code_db.getCommonCode("02");

                        string cityNo = string.Empty;

                        //資料從第四筆開始 最後一筆是合計不進資料庫
                        for (int j = 3; j < sheet.PhysicalNumberOfRows - 1; j++)
                        {
                            if (sheet.GetRow(j).GetCell(0).ToString().Trim() != "" && sheet.GetRow(j).GetCell(0).ToString().Trim() != "全台平均")
                            {
                                DataRow row = dt.NewRow();
                                cityNo = Common.GetCityCodeItem(dtCode, sheet.GetRow(j).GetCell(0).ToString().Trim());//縣市代碼
                                if (cityNo == "")
                                {
                                    throw new Exception("第" + (j + 1) + "筆資料：" + sheet.GetRow(j).GetCell(0).ToString().Trim() + "不是一個正確的縣市名稱");
                                }
                                row["Edu_CityNo"] = cityNo;//縣市代碼
                                row["Edu_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                                row["Edu_15upJSDownRateYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//
                                row["Edu_15upJSDownRate"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//
                                row["Edu_15upHSRateYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//
                                row["Edu_15upHSRate"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//
                                row["Edu_15upUSUpRateYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//
                                row["Edu_15upUSUpRate"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//
                                row["Edu_ESStudentDropOutRateYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//
                                row["Edu_ESStudentDropOutRate"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//
                                row["Edu_JSStudentDropOutRateYear"] = sheet.GetRow(1).GetCell(5).ToString().Trim().Replace("年", "");//
                                row["Edu_JSStudentDropOutRate"] = sheet.GetRow(j).GetCell(5).ToString().Trim();//
                                row["Edu_ESStudentsYear"] = sheet.GetRow(1).GetCell(6).ToString().Trim().Replace("年", "");//
                                row["Edu_ESStudents"] = sheet.GetRow(j).GetCell(6).ToString().Trim();//
                                row["Edu_JSStudentsYear"] = sheet.GetRow(1).GetCell(7).ToString().Trim().Replace("年", "");//
                                row["Edu_JSStudents"] = sheet.GetRow(j).GetCell(7).ToString().Trim();//
                                row["Edu_HSStudentsYear"] = sheet.GetRow(1).GetCell(8).ToString().Trim().Replace("年", "");//
                                row["Edu_HSStudents"] = sheet.GetRow(j).GetCell(8).ToString().Trim();//
                                row["Edu_ESToHSIndigenousYear"] = sheet.GetRow(1).GetCell(9).ToString().Trim().Replace("年", "");//
                                row["Edu_ESToHSIdigenous"] = sheet.GetRow(j).GetCell(9).ToString().Trim();//
                                row["Edu_ESToHSIndigenousRateYear"] = sheet.GetRow(1).GetCell(10).ToString().Trim().Replace("年", "");//
                                row["Edu_ESToHSIndigenousRate"] = sheet.GetRow(j).GetCell(10).ToString().Trim();//
                                row["Edu_ESJSNewInhabitantsYear"] = sheet.GetRow(1).GetCell(11).ToString().Trim().Replace("年", "");//
                                row["Edu_ESJSNewInhabitants"] = sheet.GetRow(j).GetCell(11).ToString().Trim();//
                                row["Edu_ESJSNewInhabitantsRateYear"] = sheet.GetRow(1).GetCell(12).ToString().Trim().Replace("年", "");//
                                row["Edu_ESToJSNewInhabitantsRate"] = sheet.GetRow(j).GetCell(12).ToString().Trim();//
                                row["Edu_ESJSTeachersYear"] = sheet.GetRow(1).GetCell(13).ToString().Trim().Replace("年", "");//
                                row["Edu_ESJSTeachers"] = sheet.GetRow(j).GetCell(13).ToString().Trim();//
                                row["Edu_ESJSTeachersOfStudentRateYear"] = sheet.GetRow(1).GetCell(14).ToString().Trim().Replace("年", "");//
                                row["Edu_ESJSTeachersOfStudentRate"] = sheet.GetRow(j).GetCell(14).ToString().Trim();//
                                row["Edu_BudgetYear"] = sheet.GetRow(1).GetCell(15).ToString().Trim().Replace("年", "");//
                                row["Edu_Budget"] = sheet.GetRow(j).GetCell(15).ToString().Trim();//
                                row["Edu_BudgetUpRateYearDesc"] = sheet.GetRow(1).GetCell(16).ToString().Trim().Replace("年", "");//
                                row["Edu_BudgetUpRate"] = sheet.GetRow(j).GetCell(16).ToString().Trim();//
                                row["Edu_ESToHSAvgBudgetYear"] = sheet.GetRow(1).GetCell(17).ToString().Trim().Replace("年", "");//
                                row["Edu_ESToHSAvgBudget"] = sheet.GetRow(j).GetCell(17).ToString().Trim();//
                                row["Edu_ESJSPCNumYear"] = sheet.GetRow(1).GetCell(18).ToString().Trim().Replace("年", "");//
                                row["Edu_ESJSPCNum"] = sheet.GetRow(j).GetCell(18).ToString().Trim();//
                                row["Edu_ESJSAvgPCNumYear"] = sheet.GetRow(1).GetCell(19).ToString().Trim().Replace("年", "");//
                                row["Edu_ESJSAvgPCNum"] = sheet.GetRow(j).GetCell(19).ToString().Trim();//
                                row["Edu_CreateDate"] = dtNow;
                                row["Edu_CreateID"] = LogInfo.mGuid;//上傳者GUID
                                row["Edu_CreateName"] = LogInfo.name;//上傳者姓名
                                row["Edu_Status"] = "A";
                                row["Edu_Version"] = strMaxVersion;

                                if (chkYear == "")
                                    chkYear = sheet.GetRow(1).GetCell(6).ToString().Trim().Replace("年", "");

                                dt.Rows.Add(row);
                            }

                        }

                        if (dt.Rows.Count > 0)
                        {
                            BeforeBulkCopy(oConn, myTrans, chkYear);//檢查資料表裡面是不是有該年的資料
                            DoBulkCopy(myTrans, dt, strErrorMsg);//匯入
                                                                 //最後再commit
                            myTrans.Commit();
                            if (strErrorMsg == "")
                            {
                                strErrorMsg = "上傳成功";
                            }

                        }
                    }

                }
                catch (Exception ex)
                {
                    strErrorMsg += ex.Message;
                    myTrans.Rollback();
                }
                finally
                {
                    oCmd.Connection.Close();
                    oConn.Close();
                    Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
                }
            }
        }

        //insert 前判斷是不是同年份有資料了
        private void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran, string chkYear)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"
                declare @chkRowCount int = 0;
                select @chkRowCount = count(*) from Education where Edu_ESStudentsYear=@chkYear and Edu_Status='A'

                if @chkRowCount>0
                    begin
                        update Education set Edu_Status='D' where Edu_ESStudentsYear=@chkYear and Edu_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Parameters.AddWithValue("@chkYear", chkYear);

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //教育 BulkCopy
        private void DoBulkCopy(SqlTransaction oTran, DataTable srcData, string errorMsg)
        {
            try
            {
                SqlBulkCopyOptions setting = SqlBulkCopyOptions.CheckConstraints | SqlBulkCopyOptions.TableLock;
                using (SqlBulkCopy sqlBC = new SqlBulkCopy(oTran.Connection, setting, oTran))
                {
                    sqlBC.BulkCopyTimeout = 600; ///設定逾時的秒數
                    //sqlBC.BatchSize = 1000; ///設定一個批次量寫入多少筆資料, 設定值太小會影響效能 
                    ////設定 NotifyAfter 屬性，以便在每複製 10000 個資料列至資料表後，呼叫事件處理常式。
                    //sqlBC.NotifyAfter = 10000;
                    ///設定要寫入的資料庫
                    sqlBC.DestinationTableName = "Education";

                    /// 對應來源與目標資料欄位 左邊：C# DataTable欄位  右邊：資料庫Table欄位
                    sqlBC.ColumnMappings.Add("Edu_CityNo", "Edu_CityNo");
                    sqlBC.ColumnMappings.Add("Edu_CityName", "Edu_CityName");
                    sqlBC.ColumnMappings.Add("Edu_15upJSDownRateYear", "Edu_15upJSDownRateYear");
                    sqlBC.ColumnMappings.Add("Edu_15upJSDownRate", "Edu_15upJSDownRate");
                    sqlBC.ColumnMappings.Add("Edu_15upHSRateYear", "Edu_15upHSRateYear");
                    sqlBC.ColumnMappings.Add("Edu_15upHSRate", "Edu_15upHSRate");
                    sqlBC.ColumnMappings.Add("Edu_15upUSUpRateYear", "Edu_15upUSUpRateYear");
                    sqlBC.ColumnMappings.Add("Edu_15upUSUpRate", "Edu_15upUSUpRate");
                    sqlBC.ColumnMappings.Add("Edu_ESStudentDropOutRateYear", "Edu_ESStudentDropOutRateYear");
                    sqlBC.ColumnMappings.Add("Edu_ESStudentDropOutRate", "Edu_ESStudentDropOutRate");
                    sqlBC.ColumnMappings.Add("Edu_JSStudentDropOutRateYear", "Edu_JSStudentDropOutRateYear");
                    sqlBC.ColumnMappings.Add("Edu_JSStudentDropOutRate", "Edu_JSStudentDropOutRate");
                    sqlBC.ColumnMappings.Add("Edu_ESStudentsYear", "Edu_ESStudentsYear");
                    sqlBC.ColumnMappings.Add("Edu_ESStudents", "Edu_ESStudents");
                    sqlBC.ColumnMappings.Add("Edu_JSStudentsYear", "Edu_JSStudentsYear");
                    sqlBC.ColumnMappings.Add("Edu_JSStudents", "Edu_JSStudents");
                    sqlBC.ColumnMappings.Add("Edu_HSStudentsYear", "Edu_HSStudentsYear");
                    sqlBC.ColumnMappings.Add("Edu_HSStudents", "Edu_HSStudents");
                    sqlBC.ColumnMappings.Add("Edu_ESToHSIndigenousYear", "Edu_ESToHSIndigenousYear");
                    sqlBC.ColumnMappings.Add("Edu_ESToHSIdigenous", "Edu_ESToHSIdigenous");
                    sqlBC.ColumnMappings.Add("Edu_ESToHSIndigenousRateYear", "Edu_ESToHSIndigenousRateYear");
                    sqlBC.ColumnMappings.Add("Edu_ESToHSIndigenousRate", "Edu_ESToHSIndigenousRate");
                    sqlBC.ColumnMappings.Add("Edu_ESJSNewInhabitantsYear", "Edu_ESJSNewInhabitantsYear");
                    sqlBC.ColumnMappings.Add("Edu_ESJSNewInhabitants", "Edu_ESJSNewInhabitants");
                    sqlBC.ColumnMappings.Add("Edu_ESJSNewInhabitantsRateYear", "Edu_ESJSNewInhabitantsRateYear");
                    sqlBC.ColumnMappings.Add("Edu_ESToJSNewInhabitantsRate", "Edu_ESToJSNewInhabitantsRate");
                    sqlBC.ColumnMappings.Add("Edu_ESJSTeachersYear", "Edu_ESJSTeachersYear");
                    sqlBC.ColumnMappings.Add("Edu_ESJSTeachers", "Edu_ESJSTeachers");
                    sqlBC.ColumnMappings.Add("Edu_ESJSTeachersOfStudentRateYear", "Edu_ESJSTeachersOfStudentRateYear");
                    sqlBC.ColumnMappings.Add("Edu_ESJSTeachersOfStudentRate", "Edu_ESJSTeachersOfStudentRate");
                    sqlBC.ColumnMappings.Add("Edu_BudgetYear", "Edu_BudgetYear");
                    sqlBC.ColumnMappings.Add("Edu_Budget", "Edu_Budget");
                    sqlBC.ColumnMappings.Add("Edu_BudgetUpRateYearDesc", "Edu_BudgetUpRateYearDesc");
                    sqlBC.ColumnMappings.Add("Edu_BudgetUpRate", "Edu_BudgetUpRate");
                    sqlBC.ColumnMappings.Add("Edu_ESToHSAvgBudgetYear", "Edu_ESToHSAvgBudgetYear");
                    sqlBC.ColumnMappings.Add("Edu_ESToHSAvgBudget", "Edu_ESToHSAvgBudget");
                    sqlBC.ColumnMappings.Add("Edu_ESJSPCNumYear", "Edu_ESJSPCNumYear");
                    sqlBC.ColumnMappings.Add("Edu_ESJSPCNum", "Edu_ESJSPCNum");
                    sqlBC.ColumnMappings.Add("Edu_ESJSAvgPCNumYear", "Edu_ESJSAvgPCNumYear");
                    sqlBC.ColumnMappings.Add("Edu_ESJSAvgPCNum", "Edu_ESJSAvgPCNum");
                    sqlBC.ColumnMappings.Add("Edu_CreateDate", "Edu_CreateDate");
                    sqlBC.ColumnMappings.Add("Edu_CreateID", "Edu_CreateID");
                    sqlBC.ColumnMappings.Add("Edu_CreateName", "Edu_CreateName");
                    sqlBC.ColumnMappings.Add("Edu_Status", "Edu_Status");
                    sqlBC.ColumnMappings.Add("Edu_Version", "Edu_Version");
                    /// 開始寫入資料
                    sqlBC.WriteToServer(srcData);
                }
            }
            catch (Exception ex)
            {
                strErrorMsg += "教育匯入 error：" + ex.Message.ToString() + "\n";
            }

        }

        //判斷Token是否正確
        private bool VeriftyToken(string clientToken)
        {
            if (string.IsNullOrEmpty(clientToken)) return false;

            string serverToken = HttpContext.Current.Session["Token"].ToString();
            if (clientToken.Equals(serverToken))
                return true;
            else
                return false;
        }
    }
}