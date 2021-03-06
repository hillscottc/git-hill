﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace WebServicesMvcApp1.Models.ModelViews.RemoteWebService
{
    public class EditModelView
    {
        public int Id { get; set; }
        public string ServiceName { get; set; }
        public string ServiceAddress { get; set; }
        public string Wsdl { get; set; }
        public virtual ICollection<Method> Methods { get; set; }

        public EditModelView() {}

        public EditModelView(Models.RemoteWebService rws)
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
