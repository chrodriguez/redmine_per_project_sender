module RedminePerProjectSender
  module MailerPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method :mail_without_project_sender, :mail
        alias_method :mail, :mail_with_project_sender
      end
      
    end

    module InstanceMethods
      # Overrides the mail method trying to
      # get per project mail from configuration
      def mail_with_project_sender(headers={}, &block)
        headers.reverse_merge! 'X-Mailer' => 'Redmine',
          'X-Redmine-Host' => Setting.host_name,
          'X-Redmine-Site' => Setting.app_title,
          'X-Auto-Response-Suppress' => 'All',
          'Auto-Submitted' => 'auto-generated',
          'From' => mail_from_project_sender,
          'List-Id' => "<#{mail_from_project_sender.to_s.tr('@', '.')}>"

        # Replaces users with their email addresses
        [:to, :cc, :bcc].each do |key|
          if headers[key].present?
            headers[key] = self.class.email_addresses(headers[key])
          end
        end

        # Removes the author from the recipients and cc
        # if the author does not want to receive notifications
        # about what the author do
        if @author && @author.logged? && @author.pref.no_self_notified
          addresses = @author.mails
          headers[:to] -= addresses if headers[:to].is_a?(Array)
          headers[:cc] -= addresses if headers[:cc].is_a?(Array)
        end

        if @author && @author.logged?
          redmine_headers 'Sender' => @author.login
        end

        # Blind carbon copy recipients
        if Setting.bcc_recipients?
          headers[:bcc] = [headers[:to], headers[:cc]].flatten.uniq.reject(&:blank?)
          headers[:to] = nil
          headers[:cc] = nil
        end

        if @message_id_object
          headers[:message_id] = "<#{self.class.message_id_for(@message_id_object)}>"
        end
        if @references_objects
          headers[:references] = @references_objects.collect {|o| "<#{self.class.references_for(o)}>"}.join(' ')
        end

        if block_given?
          super headers, &block
        else
          super headers do |format|
            format.text
            format.html unless Setting.plain_text_mail?
          end
        end
      end

      private
        # try to return mail_from project configuration
        def mail_from_project_sender
          sender = if @issue
            p = @issue.project
            s = CustomField.find_by_name('project-sender-email')
            p.custom_value_for(s).try(:value) if p.present? && s.present?
          end
          (sender.present? && sender) || Setting.mail_from
        end
    end # module InstanceMethods
  end # module MailerPatch
end # module RedminePerProjectSender

# Add module to Mailer class
Mailer.send(:include, RedminePerProjectSender::MailerPatch)


class ActionMailer::Base
        alias_method :mail_with_project_sender,  :mail
end
