// Import Rails' UJS library, which handles things like non-GET links and forms with CSRF protection
import Rails from "@rails/ujs";

// Import Turbo to handle modern navigation and form submissions without full page reloads
import { Turbo } from "@hotwired/turbo-rails";

// Stimulus setup if you are using Stimulus controllers
import { Application } from "@hotwired/stimulus";
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers";

const application = Application.start();
const context = require.context("../controllers", true, /\.js$/);
application.load(definitionsFromContext(context));

// Start Rails UJS and Turbo
Rails.start();
Turbo.start();

// Export the Stimulus application for potential use elsewhere
export { application };
