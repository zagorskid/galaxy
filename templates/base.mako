<%namespace name="galaxy_client" file="/galaxy_client_app.mako" />
<% self.js_app = None %>

<% _=n_ %>
<!DOCTYPE HTML>
<html>
    <!--base.mako-->
    ${self.init()}
    <head>
        <title>${self.title()}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        ${self.metas()}
        ${self.stylesheets()}
        ${self.javascripts()}
        ${self.javascript_app()}
        
        <!-- Begin Cookie Consent plugin -->
        <script type="text/javascript">
            window.cookieconsent_options = {"message":"The Galaxy Platform uses cookies to ensure you get the best experience using our Service.","dismiss":"Got it!","learnMore":"More info","link":"http://www.paad.pl","theme":"dark-bottom"};
        </script>
        <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/cookieconsent2/1.0.9/cookieconsent.min.js"></script>
        <!-- End Cookie Consent plugin -->
        
    </head>
    <body class="inbound">
        ${next.body()}
    </body>
</html>

## Default title
<%def name="title()"></%def>

## Default init
<%def name="init()"></%def>

## Default stylesheets
<%def name="stylesheets()">
    ${h.css('base')}
</%def>

## Default javascripts
<%def name="javascripts()">
    
    ## Send errors to Sntry server if configured
    %if app.config.sentry_dsn:
        ${h.js( "libs/tracekit", "libs/raven" )}
        <script>
            Raven.config('${app.config.sentry_dsn_public}').install();
            %if trans.user:
                Raven.setUser( { email: "${trans.user.email|h}" } );
            %endif
        </script>
    %endif

    ${h.js(
        "libs/jquery/jquery",
        "libs/jquery/jquery.migrate",
        "libs/jquery/select2",
        "libs/jquery/jquery.event.hover",
        "libs/jquery/jquery.form",
        "libs/jquery/jquery.rating",
        "libs/jquery.sparklines",
        "libs/bootstrap",
        "libs/underscore",
        "libs/backbone/backbone",
        "libs/handlebars.runtime",
        "libs/require",
        "galaxy.base",
        "galaxy.panels",
        "galaxy.autocom_tagging"
    )}

    <script type="text/javascript">
        ## global galaxy object
        window.Galaxy = window.Galaxy || {};

        ## global configuration object
        window.Galaxy.root = '${h.url_for( "/" )}';
        window.galaxy_config = { root: window.Galaxy.root };

        ## console protection
        window.console = window.console || {
            log     : function(){},
            debug   : function(){},
            info    : function(){},
            warn    : function(){},
            error   : function(){},
            assert  : function(){}
        };

        ## configure require
        require.config({
            baseUrl: "${h.url_for('/static/scripts') }",
            shim: {
                "libs/underscore": { exports: "_" },
                "libs/backbone/backbone": { exports: "Backbone" }
            },
            urlArgs: 'v=${app.server_starttime}'
        });
    </script>

    %if not form_input_auto_focus is UNDEFINED and form_input_auto_focus:
        <script type="text/javascript">
            $(document).ready( function() {
                // Auto Focus on first item on form
                if ( $("*:focus").html() == null ) {
                    $(":input:not([type=hidden]):visible:enabled:first").focus();
                }
            });
        </script>
    %endif

</%def>

<%def name="javascript_app()">
    ${ galaxy_client.load( app=self.js_app ) }
</%def>

## Additional metas can be defined by templates inheriting from this one.
<%def name="metas()"></%def>
