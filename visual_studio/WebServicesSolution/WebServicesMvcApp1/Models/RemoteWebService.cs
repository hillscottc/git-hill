//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace WebServicesMvcApp1.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class RemoteWebService
    {
        public RemoteWebService()
        {
            this.Methods = new HashSet<Method>();
        }
    
        public int Id { get; set; }
        public string ServiceName { get; set; }
        public string ServiceAddress { get; set; }
        public string Wsdl { get; set; }
    
        public virtual ICollection<Method> Methods { get; set; }
    }
}
