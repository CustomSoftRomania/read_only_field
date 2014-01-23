require 'spec_helper'

class Issue < ActiveRecord::Base
  include ReadOnlyField
  has_read_only_field :estimated_time, :allow => %w(Manager)
  has_read_only_field :spend_time, :allow => %w(Manager Developer Tester)
end

class MultipleIssue < ActiveRecord::Base
  include ReadOnlyField
  self.table_name = :issues

  has_read_only_field :estimated_time, :allow => %w(Manager)
end

describe "read_only_field" do
  it "should respond to has_read_only_field" do
    Issue.should respond_to(:has_read_only_field)
  end

  it "should define check_read_only_fields instance method" do
    issue = Issue.new
    issue.should respond_to(:check_read_only_fields)
  end

  it "should define estimated_time_readonly_roles" do
    Issue.should respond_to(:estimated_time_readonly_roles)
  end

  it "should define readonly_fields" do
    Issue.readonly_fields.should eql([:estimated_time, :spend_time])
  end

  it "should return [:manager] for estimated_time_readonly_roles" do
    Issue.estimated_time_readonly_roles.should eql(%w(Manager))
  end

  it "should call check_read_only_fields when saved" do
    issue = Issue.new(name: "Test name")
    issue.should_receive(:check_read_only_fields)
    issue.save
  end

  it "gets readonly roles for estimated_time" do
    issue = Issue.new()
    issue.readonly_roles_for(:estimated_time).should eql(%w(Manager))
  end

  it "should allow save only for first run" do
    issue = Issue.new(estimated_time: 0.3)
    issue.save.should eql(true)

    issue.estimated_time = 0.5
    issue.should_receive(:user_roles).and_return([Struct.new(:name).new("Developer")])
    issue.save.should eql(false)
    issue.errors[:estimated_time].count.should eql(1)
  end

  it "should allow save for multiple roles if one role matches" do
    issue = MultipleIssue.new(estimated_time: 0.3)
    issue.save.should eql(true)

    issue.estimated_time = 0.5
    issue.should_receive(:user_roles).and_return([
                                                   Struct.new(:name).new("Developer"),
                                                   Struct.new(:name).new("Manager")
                                                 ])
    issue.save.should eql(true)
  end
end
