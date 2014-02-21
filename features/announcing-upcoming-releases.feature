Feature: Announcing upcoming releases
  As an editor publishing statistics
  In order to inform the public when statistics will become available
  I can announce the release date of statistics

Background:
  Given I am an editor in the organisation "Bureaux of statistics"

Scenario: Announcing a statistic before publication
  Given a draft statistics publication for the organisation "Bureaux of statistics"
  When I announce the release date of the publication
  Then I should see that the publication is announced
  And I should see the change to the announcement date in the change notes
