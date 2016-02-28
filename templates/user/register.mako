<%!
#This is a hack, we should restructure templates to avoid this.
def inherit(context):
    if context.get('trans').webapp.name == 'galaxy' and context.get( 'use_panels', True ):
        return '/webapps/galaxy/base_panels.mako'
    else:
        return '/base.mako'
%>
<%inherit file="${inherit(context)}"/>

<%def name="init()">
<%
    self.has_left_panel=False
    self.has_right_panel=False
    self.active_view="user"
    self.message_box_visible=False
%>
</%def>

<%namespace file="/message.mako" import="render_msg" />

<%def name="center_panel()">
    ${body()}
</%def>

<%def name="javascripts()">
    ${parent.javascripts()}
</%def>

<%def name="body()">
    <div style="${ 'margin: 1em;' if context.get( 'use_panels', True ) else '' }">

        %if redirect_url:
            <script type="text/javascript">  
                top.location.href = '${redirect_url | h}';
            </script>
        %elif message:
            ${render_msg( message, status )}
        %endif

        ## An admin user may be creating a new user account, in which case we want to display the registration form.
        ## But if the current user is not an admin user, then don't display the registration form.
        %if ( cntrller=='admin' and trans.user_is_admin() ) or not trans.user:
            ${render_registration_form()}
        %endif

    </div>
</%def>

<%def name="render_registration_form( form_action=None )">

    <div>
		<h1>Registration</h1>
		<p>
			This Galaxy Platform is a part of the PAAD Infrastructure. 
			To be able to use this Service you need to create a PAAD account, by clicking on the button below.
			The registration form will be opened in a new window.
		</p>
		<p>
			Please read and accept <a href="${trans.app.config.get('terms_url', None)}" target="_blank">Terms and Conditions for use of this Service</a>
			before registration.
		</p>	
		<a href="https://paad.us.edu.pl/site/signup" target="_blank" class="btn btn-primary" role="button">Create a new PAAD Account</a>
    </div>

</%def>
