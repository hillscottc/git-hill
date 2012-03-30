using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Diagnostics;
using System.Configuration;
//using IronPython.Hosting;
//using Microsoft.Scripting.Hosting;

namespace ConfigAdmin.rdx
{
    public partial class rdx2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }


        //public static dynamic RunIronPythonScript(string fileName)
        //{
        //    var ipy = IronPython.Hosting.Python.CreateRuntime();
        //    try
        //    {
        //        dynamic test = ipy.ExecuteFile(fileName);

        //        return test;
        //    }
        //    catch (Exception e)
        //    {
                
        //        var engine = IronPython.Hosting.Python.GetEngine(ipy);
        //        ExceptionOperations eo = engine.GetService<ExceptionOperations>();
        //        string error = eo.FormatException(e);
        //        throw new Exception(error);
        //    }
        //}



        protected void Button1_Click(object sender, EventArgs e)
        {

   

            //ProcessStartInfo startInfo; Process process;
            //string directory = ConfigurationManager.AppSettings["ScriptDir"];
            //string script = ConfigurationManager.AppSettings["ScriptExeCmd"];

  
            //ScriptEngine py = Python.CreateEngine();
            //ScriptScope scope = py.CreateScope();
            //ScriptSource source =  py.CreateScriptSourceFromFile(directory + "\\" + script);

            ////dynamic testmodule = py.UseFile(directory + "\\" + script);

            //source.Execute();
            //source.ToString();
            //tbPyOut.Text = source.ToString();

            //string s = RunIronPythonScript(directory + "\\" + script);
            //Microsoft.Scripting.Hosting.ScriptEngine engine =  IronPython.Hosting.Python.CreateEngine();
            //var s = engine.ExecuteFile(directory + "\\" + script);
            //engine.Operations.Invoke(s.GetVariable("hey"));


            //Debug.WriteLine(engine.ExecuteFile(directory + "\\" + script));

            //tbPyOut.Text = engine.Operations.Invoke(s.GetVariable("hey"));
            //ScriptEngine engine = Python.CreateEngine();
            //ScriptScope scope = engine.CreateScope(); 
//            ScriptSource source = engine.CreateScriptSourceFromString(
//            @"    
//            def fun():  
//                    print 'hello from example function'  
//            ");
            //var ipy = IronPython.Hosting.Python.CreateRuntime();
            //dynamic d =  ipy.ExecuteFile(directory + "\\" + script);

            //<Employee>("employee")
           
            //dynamic g = ipy.ExecuteFile(directory + "\\" + script).GetVariable<string>("hey");
            
            
            
            //tbPyOut.Text = g;

            //ipy.ExecuteFile('m').ToString()

            //source.Execute(scope);

            //tbPyOut.Text = engine.Operations.Invoke(scope.GetVariable("fun"));

            //Debug.WriteLine(engine.Operations.Invoke(scope.GetVariable("fun")));
 

        }


        //protected void ldsEnv_Selecting(object sender, LinqDataSourceSelectEventArgs e)
        //{
        //    List<string> categoryIDs = new List<string>();


        //    foreach (ListItem li in lstEnvs.Items)
        //    {
        //        if (li.Selected)
        //        {
        //            categoryIDs.Add(li.Value);
        //        }
        //    }

        //    ConfigAdmin.DataClasses1DataContext db = new ConfigAdmin.DataClasses1DataContext();

        //    e.Result = db.Infras.Where(p => categoryIDs.Contains(p.env)).OrderBy(p => p.name);
        //}

    }
}