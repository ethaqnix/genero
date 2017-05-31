"use strict";

modulum('newWidget', ['sessionEndWidget', 'WidgetFactory'],
    function(context, cls) {

        cls.newWidget = context.oo.Class(cls.baseWidget, function($super) {
            return {
                __name: "newWidget",
                var redirectionLink = this._element.getElementsByClassName("redirectionLink")[0];
                redirectionLink.title = i18n.t("mycusto.session.redirectionText");
                var url = "http://www.google.com";
                redirectionLink.href = url;

                var modelHelper = new cls.ModelHelper(this);
                 // check if an application is running in the current session before reloading
                if(!modelHelper.getCurrentApplication()) {
                    window.location = url;
                }
            };
        });
        cls.WidgetFactory.register('widgetType', 'widgetStyle', cls.newWidget);
    });

// update redirection link url of the template
