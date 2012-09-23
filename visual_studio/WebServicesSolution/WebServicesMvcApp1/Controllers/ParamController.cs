using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebServicesMvcApp1.Models;

namespace WebServicesMvcApp1.Controllers
{
    public class ParamController : Controller
    {
        private WebServiceDataModelContainer db = new WebServiceDataModelContainer();

        //
        // GET: /Param/

        public ActionResult Index()
        {
            var wsparams = db.Params.Include(p => p.Method);
            return View(wsparams.ToList());
        }

        //
        // GET: /Param/Details/5

        public ActionResult Details(int id = 0)
        {
            Param param = db.Params.Find(id);
            if (param == null)
            {
                return HttpNotFound();
            }
            return View(param);
        }

        //
        // GET: /Param/Create

        public ActionResult Create()
        {
            ViewBag.MethodId = new SelectList(db.Methods, "Id", "MethodName");
            return View();
        }

        //
        // POST: /Param/Create

        [HttpPost]
        public ActionResult Create(Param param)
        {
            if (ModelState.IsValid)
            {
                db.Params.Add(param);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.MethodId = new SelectList(db.Methods, "Id", "MethodName", param.MethodId);
            return View(param);
        }

        //
        // GET: /Param/Edit/5

        public ActionResult Edit(int id = 0)
        {
            Param param = db.Params.Find(id);
            if (param == null)
            {
                return HttpNotFound();
            }
            ViewBag.MethodId = new SelectList(db.Methods, "Id", "MethodName", param.MethodId);
            return View(param);
        }

        //
        // POST: /Param/Edit/5

        [HttpPost]
        public ActionResult Edit(Param param)
        {
            if (ModelState.IsValid)
            {
                db.Entry(param).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MethodId = new SelectList(db.Methods, "Id", "MethodName", param.MethodId);
            return View(param);
        }

        //
        // GET: /Param/Delete/5

        public ActionResult Delete(int id = 0)
        {
            Param param = db.Params.Find(id);
            if (param == null)
            {
                return HttpNotFound();
            }
            return View(param);
        }

        //
        // POST: /Param/Delete/5

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            Param param = db.Params.Find(id);
            db.Params.Remove(param);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            db.Dispose();
            base.Dispose(disposing);
        }
    }
}