using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace WebServicesMvcApp1.Models.ModelViews.RemoteWebService
{
    public class DetailModelView
    {
        public int Id { get; set; }
        public string ServiceName { get; set; }
        public string ServiceAddress { get; set; }
        public string Wsdl { get; set; }
        public virtual ICollection<Method> Methods { get; set; }
        //public IEnumerable<SelectListItem> MethodList
        //{
        //    get
        //    {
        //        return new SelectList(this.Methods, "Id", "MethodName");
        //    }
        //}

        public DetailModelView() {}

        public DetailModelView(Models.RemoteWebService rws)
        {
            setModelView(rws);
        }

        private void setModelView(Models.RemoteWebService rws)
        {
            this.Id = rws.Id;
            this.ServiceName = rws.ServiceName;
            this.ServiceAddress = rws.ServiceAddress;
            this.Wsdl = rws.Wsdl;
            this.Methods = rws.Methods;
        }

        //public RemoteWebService()
        //{
        //    this.Methods = new HashSet<Method>();
        //}


    }
}
