import computed from "ember-addons/ember-computed-decorators";
import { isAppWebview, isiOSPWA } from "discourse/lib/utilities";

export default Ember.Controller.extend({
  showTop: true,
  showFooter: false,
  router: Ember.inject.service(),

  @computed
  canSignUp() {
    return (
      !Discourse.SiteSettings.invite_only &&
      Discourse.SiteSettings.allow_new_registrations &&
      !Discourse.SiteSettings.enable_sso
    );
  },

  @computed
  loginRequired() {
    return Discourse.SiteSettings.login_required && !Discourse.User.current();
  },

  @computed
  showFooterNav() {
    return isAppWebview() || isiOSPWA();
  }
});
