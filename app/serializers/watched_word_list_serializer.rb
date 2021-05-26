# frozen_string_literal: true

class WatchedWordListSerializer < ApplicationSerializer
  attributes :actions, :words, :regular_expressions, :compiled_regular_expressions, :compiled_regular_expression_errors

  def actions
    SiteSetting.tagging_enabled ? WatchedWord.actions.keys
                                : WatchedWord.actions.keys.filter { |k| k != :tag }
  end

  def words
    object.map do |word|
      WatchedWordSerializer.new(word, root: false)
    end
  end

  # No point making this site setting `client: true` when it's only used
  # in the admin section
  def regular_expressions
    SiteSetting.watched_words_regular_expressions?
  end

  def compiled_regular_expressions
    expressions = {}
    actions.each do |action|
      expressions[action] = WordWatcher.word_matcher_regexp(action)&.source
    end
    expressions
  end

  def compiled_regular_expression_errors
    errors = {}
    actions.each do |action|
      begin
        WordWatcher.word_matcher_regexp(action, raise_errors: true)
      rescue RegexpError
        errors[action] = true
      end
    end
    errors
  end
end
