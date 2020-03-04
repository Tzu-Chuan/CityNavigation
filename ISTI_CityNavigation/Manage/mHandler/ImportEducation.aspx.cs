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
        ImportData_Log idl_db = new ImportData_Log();
        //建立共用參數
        string strErrorMsg = "";
        int strMaxVersion = 0;
        DateTime dtNow = DateTime.Now;
        protected void Page_Load(object sender, EventArgs e)
        {
            //讀取Token值
            string token = (string.IsNullOrEmpty(Request["InfoToken"])) ? "" : Request["InfoToken"].ToString().Trim();
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
                dt.Columns.Add("Edu_CityNo", typeof(string)).MaxLength = 2;
                dt.Columns.Add("Edu_CityName", typeof(string)).MaxLength = 10;
                dt.Columns.Add("Edu_15upJSDownRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_15upJSDownRate", typeof(string)).MaxLength = 7;
                dt.Columns.Add("Edu_15upHSRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_15upHSRate", typeof(string)).MaxLength = 7;
                dt.Columns.Add("Edu_15upUSUpRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_15upUSUpRate", typeof(string)).MaxLength = 7;
                dt.Columns.Add("Edu_ESStudentDropOutRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESStudentDropOutRate", typeof(string)).MaxLength = 50;
                dt.Columns.Add("Edu_JSStudentDropOutRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_JSStudentDropOutRate", typeof(string)).MaxLength = 50;
                dt.Columns.Add("Edu_ESStudentsYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESStudents", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_JSStudentsYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_JSStudents", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_HSStudentsYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_HSStudents", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_ESToHSIndigenousYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESToHSIdigenous", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_ESToHSIndigenousRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESToHSIndigenousRate", typeof(string)).MaxLength = 50;
                dt.Columns.Add("Edu_ESJSNewInhabitantsYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESJSNewInhabitants", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_ESJSNewInhabitantsRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESToJSNewInhabitantsRate", typeof(string)).MaxLength = 50;
                dt.Columns.Add("Edu_ESJSTeachersYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESJSTeachers", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_ESJSTeachersOfStudentRateYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESJSTeachersOfStudentRate", typeof(string)).MaxLength = 50;
                dt.Columns.Add("Edu_BudgetYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_Budget", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_BudgetUpRateYearDesc", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_BudgetUpRate", typeof(string)).MaxLength = 50;
                dt.Columns.Add("Edu_ESToHSAvgBudgetYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESToHSAvgBudget", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_ESJSPCNumYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESJSPCNum", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_ESJSAvgPCNumYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_ESJSAvgPCNum", typeof(string)).MaxLength = 20;
                dt.Columns.Add("Edu_HighschoolDownRemoteAreasYear", typeof(string)).MaxLength = 3;
                dt.Columns.Add("Edu_HighschoolDownRemoteAreas", typeof(string)).MaxLength = 50;
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
                        if (cellsCount != 21)
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

                                strErrorMsg = "行數:第" + (j + 1).ToString() + " 筆<br>";
                                row["Edu_CityNo"] = cityNo;//縣市代碼
                                row["Edu_CityName"] = sheet.GetRow(j).GetCell(0).ToString().Trim();//縣市名稱
                                row["Edu_15upJSDownRateYear"] = sheet.GetRow(1).GetCell(1).ToString().Trim().Replace("年", "");//15歲以上民間人口之教育程度結構-國中及以下-資料年度
                                row["Edu_15upJSDownRate"] = sheet.GetRow(j).GetCell(1).ToString().Trim();//15歲以上民間人口之教育程度結構-國中及以下
                                row["Edu_15upHSRateYear"] = sheet.GetRow(1).GetCell(2).ToString().Trim().Replace("年", "");//15歲以上民間人口之教育程度結構-高中(職)-資料年度
                                row["Edu_15upHSRate"] = sheet.GetRow(j).GetCell(2).ToString().Trim();//15歲以上民間人口之教育程度結構-高中(職)
                                row["Edu_15upUSUpRateYear"] = sheet.GetRow(1).GetCell(3).ToString().Trim().Replace("年", "");//15歲以上民間人口之教育程度結構-大專及以上-資料年度
                                row["Edu_15upUSUpRate"] = sheet.GetRow(j).GetCell(3).ToString().Trim();//15歲以上民間人口之教育程度結構-大專及以上
                                row["Edu_ESStudentDropOutRateYear"] = sheet.GetRow(1).GetCell(4).ToString().Trim().Replace("年", "");//國小學生輟學率-資料年度
                                row["Edu_ESStudentDropOutRate"] = sheet.GetRow(j).GetCell(4).ToString().Trim();//國小學生輟學率
                                row["Edu_JSStudentDropOutRateYear"] = sheet.GetRow(1).GetCell(5).ToString().Trim().Replace("年", "");//國中學生輟學率-資料年度
                                row["Edu_JSStudentDropOutRate"] = sheet.GetRow(j).GetCell(5).ToString().Trim();//國中學生輟學率
                                row["Edu_ESStudentsYear"] = sheet.GetRow(1).GetCell(6).ToString().Trim().Replace("年", "");//國小總學生數-資料年度
                                row["Edu_ESStudents"] = sheet.GetRow(j).GetCell(6).ToString().Trim();//國小總學生數
                                row["Edu_JSStudentsYear"] = sheet.GetRow(1).GetCell(7).ToString().Trim().Replace("年", "");//國中總學生數-資料年度
                                row["Edu_JSStudents"] = sheet.GetRow(j).GetCell(7).ToString().Trim();//國中總學生數
                                row["Edu_HSStudentsYear"] = sheet.GetRow(1).GetCell(8).ToString().Trim().Replace("年", "");//高中(職)總學生數-資料年度
                                row["Edu_HSStudents"] = sheet.GetRow(j).GetCell(8).ToString().Trim();//高中(職)總學生數
                                row["Edu_ESToHSIndigenousYear"] = sheet.GetRow(1).GetCell(9).ToString().Trim().Replace("年", "");//國小-高中(職)原住民學生數-資料年度
                                row["Edu_ESToHSIdigenous"] = sheet.GetRow(j).GetCell(9).ToString().Trim();//國小-高中(職)原住民學生數
                                row["Edu_ESToHSIndigenousRateYear"] = sheet.GetRow(1).GetCell(10).ToString().Trim().Replace("年", "");//國小-高中(職)原住民學生數比例-資料年度
                                row["Edu_ESToHSIndigenousRate"] = sheet.GetRow(j).GetCell(10).ToString().Trim();//國小-高中(職)原住民學生數比例
                                row["Edu_ESJSNewInhabitantsYear"] = sheet.GetRow(1).GetCell(11).ToString().Trim().Replace("年", "");//國中小新住民人數-資料年度
                                row["Edu_ESJSNewInhabitants"] = sheet.GetRow(j).GetCell(11).ToString().Trim();//國中小新住民人數
                                row["Edu_ESJSNewInhabitantsRateYear"] = sheet.GetRow(1).GetCell(12).ToString().Trim().Replace("年", "");//國中小新住民學生比例-資料年度
                                row["Edu_ESToJSNewInhabitantsRate"] = sheet.GetRow(j).GetCell(12).ToString().Trim();//國中小新住民學生比例
                                row["Edu_ESJSTeachersYear"] = sheet.GetRow(1).GetCell(13).ToString().Trim().Replace("年", "");//國中小教師數-資料年度
                                row["Edu_ESJSTeachers"] = sheet.GetRow(j).GetCell(13).ToString().Trim();//國中小教師數
                                row["Edu_ESJSTeachersOfStudentRateYear"] = sheet.GetRow(1).GetCell(14).ToString().Trim().Replace("年", "");//國中小生師比(平均每位教師教導學生數)-資料年度
                                row["Edu_ESJSTeachersOfStudentRate"] = sheet.GetRow(j).GetCell(14).ToString().Trim();//國中小生師比(平均每位教師教導學生數)
                                row["Edu_BudgetYear"] = sheet.GetRow(1).GetCell(15).ToString().Trim().Replace("年", "");//教育預算-資料年度
                                row["Edu_Budget"] = sheet.GetRow(j).GetCell(15).ToString().Trim();//教育預算
                                row["Edu_BudgetUpRateYearDesc"] = sheet.GetRow(1).GetCell(16).ToString().Trim().Replace("年", "");//教育預算成長率-資料年度敘述
                                row["Edu_BudgetUpRate"] = sheet.GetRow(j).GetCell(16).ToString().Trim();//教育預算成長率
                                row["Edu_ESToHSAvgBudgetYear"] = sheet.GetRow(1).GetCell(17).ToString().Trim().Replace("年", "");//國小-高中(職)平均每人教育預算-資料年度
                                row["Edu_ESToHSAvgBudget"] = sheet.GetRow(j).GetCell(17).ToString().Trim();//國小-高中(職)平均每人教育預算
                                row["Edu_ESJSPCNumYear"] = sheet.GetRow(1).GetCell(18).ToString().Trim().Replace("年", "");//國中小教學電腦數-資料年度
                                row["Edu_ESJSPCNum"] = sheet.GetRow(j).GetCell(18).ToString().Trim();//國中小教學電腦數
                                row["Edu_ESJSAvgPCNumYear"] = sheet.GetRow(1).GetCell(19).ToString().Trim().Replace("年", "");//國中小平均每人教學電腦數-資料年度
                                row["Edu_ESJSAvgPCNum"] = sheet.GetRow(j).GetCell(19).ToString().Trim();//國中小平均每人教學電腦數
                                row["Edu_HighschoolDownRemoteAreasYear"] = sheet.GetRow(1).GetCell(20).ToString().Trim().Replace("年", "");//高級中等以下偏遠地區學校-資料年度
                                row["Edu_HighschoolDownRemoteAreas"] = sheet.GetRow(j).GetCell(20).ToString().Trim();//高級中等以下偏遠地區學校
                                row["Edu_CreateDate"] = dtNow;
                                row["Edu_CreateID"] = LogInfo.mGuid;//上傳者GUID
                                row["Edu_CreateName"] = LogInfo.name;//上傳者姓名
                                row["Edu_Status"] = "A";
                                row["Edu_Version"] = strMaxVersion;

                                dt.Rows.Add(row);
                            }

                        }

                        if (dt.Rows.Count > 0)
                        {

                            strErrorMsg = "";
                            BeforeBulkCopy(oConn, myTrans);//檢查資料表裡面是不是有該年的資料
                            DoBulkCopy(myTrans, dt);//匯入
                            myTrans.Commit();     //最後再commit
                        }
                    }

                }
                catch (Exception ex)
                {
                    strErrorMsg += "錯誤訊息:" + ex.Message + "<br>";
                    strErrorMsg += "(欄位名稱請參考上傳範例檔)";
                    myTrans.Rollback();
                }
                finally
                {
                    oCmd.Connection.Close();
                    oConn.Close();

                    if (strErrorMsg == "")
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:教育 , 狀態：上傳成功";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('教育匯入成功');</script>");
                    }
                    else
                    {
                        /// Log
                        idl_db._IDL_Type = "ISTI";
                        idl_db._IDL_IP = Common.GetIPv4Address();
                        idl_db._IDL_Description = "檔案類別:教育 , 狀態：上傳失敗";
                        idl_db._IDL_ModId = LogInfo.mGuid;
                        idl_db._IDL_ModName = LogInfo.name;
                        idl_db.addLog();
                        Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + strErrorMsg.Replace("'", "") + "');</script>");
                    }
                }
            }
        }

        //insert 前判斷是不是同年份有資料了
        private void BeforeBulkCopy(SqlConnection oConn, SqlTransaction oTran)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@"
                declare @chkRowCount int = 0;
                select @chkRowCount = count(*) from Education where Edu_Status='A'

                if @chkRowCount>0
                    begin
                        update Education set Edu_Status='D' where Edu_Status='A'
                    end
            ");
            SqlCommand oCmd = oConn.CreateCommand();
            oCmd.CommandText = sb.ToString();

            oCmd.Transaction = oTran;
            oCmd.ExecuteNonQuery();
        }

        //教育 BulkCopy
        private void DoBulkCopy(SqlTransaction oTran, DataTable srcData)
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
                sqlBC.ColumnMappings.Add("Edu_HighschoolDownRemoteAreasYear", "Edu_HighschoolDownRemoteAreasYear");
                sqlBC.ColumnMappings.Add("Edu_HighschoolDownRemoteAreas", "Edu_HighschoolDownRemoteAreas");
                sqlBC.ColumnMappings.Add("Edu_CreateDate", "Edu_CreateDate");
                sqlBC.ColumnMappings.Add("Edu_CreateID", "Edu_CreateID");
                sqlBC.ColumnMappings.Add("Edu_CreateName", "Edu_CreateName");
                sqlBC.ColumnMappings.Add("Edu_Status", "Edu_Status");
                sqlBC.ColumnMappings.Add("Edu_Version", "Edu_Version");
                /// 開始寫入資料
                sqlBC.WriteToServer(srcData);
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