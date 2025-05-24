# Analytics Engineer Meetup assignment

Note that sharing this assignment is *not allowed*, this assignment is *not* in the public domain.

## Context: meetup.com

[Meetup.com](http://www.meetup.com) is a popular online platform with the aim of bringing together people with a shared interest in real-life events (Meetups). The Meetup community is composed of groups, where each group has a particular interest and organises events.

Users of meetup.com can become member of one or more groups. Whenever a group organises an event, members of that group have the opportunity to RSVP for an event (yes, we're using RSVP as a verb here). The RSVP for an event can be either a Yes or No answer, meaning respectively that the member is either planning to attend the event or is not. Not RSVP-ing to an event can be interpreted as a No.

Additionally, groups express the interests that they ostensibly have in terms of a number of topics (e.g. the [Spiritual Psychology Meetup](http://www.meetup.com/Spiritual-Psychology-Meetup/) has listed as topics: Philosophy, Self Exploration, Transformation, Meditation, etc.).

In summary, the essential entities and relations in the meetup.com ecosystem are:

- Users can join groups (becoming members)
- Groups have an organiser
- Groups discuss a set of topics
- Groups organise events
- Members can RSVP to events (Yes or No)
- An event is hosted at a venue

Apart from these basics, both groups, users, members, events and venues have particular metadata. You'll want to do some exploration of your own.

A special case of Meetup events is what we call tech meetups. These are events focusing on technology (usually Information Technology / software engineering / computer science), with a typical conference style setup, where there are presentations and the members that attend are audience. Tech meetups are generally organized with the goal of knowledge sharing within the professional IT community. However, since these events are often attended by individuals with relevant and sometimes scarce skills in what are considered cutting edge technologies, these events are also popular targets for sponsorships from organization who are actively hiring software engineers or data scientists (see [here](https://xebia.com/blog/the-dutch-data-meetup-ecosystem/)).

# The assignment

The goal of the analytics engineering assignment is to take the data that is provided in the `data` folder, load it into Databricks to make it query-able and use dbt to create data marts.

### Suggested approach

We would like you to:

1. Use Databricks as your warehouse. If you do not have access to a Databricks workspace, sign up for their 14 day trial [here](https://www.databricks.com/try-databricks) (Try Databricks -> Continue with Express Setup -> etc.).
1. Create a public GitHub repository.
1. Add a dbt project to your GitHub repository and connect it to Databricks.
1. Upload the files in `data` to Databricks. Treat these as sources.
1. Use your dbt project to transform data from these sources through to data marts.
    * You are free to choose whatever naming conventions, data modeling methodology, processes, etc. of your choosing.
1. Add a `Getting Started` section to your `README.md` to allow others to replicate what you have done.
1. Show off! dbt is a central part of the Senior Analytics Engineer role, use this project as a showcase of your skills and a demonstration of the knowledge you have to make you a success in this role. For example, do you know all about CICD, then add a CI pipeline! Are you familiar with dealing with large volumes of data, then make your models incremental!

Note that this dbt project will also be the starting point for discussions during the interview, so be prepared for questions like:
* How would you design this model if the data updated daily?
* Who would you see as being the owner of this model?
* If I want this data exposed in a dashboard, can I connect to this model directly or do I need to refactor it first?
* Etc.
 
### The data

You have received data for all Meetup groups in the technology category within an area spanning a large part of The Netherlands, Belgium and some part of Germany (roughly all groups within a 100-mile radius from Amsterdam). The data contains information on groups, users, group membership, events and event RSVPs.

Data is delivered in a number of separate files containing a single JSON blob of encoded arrays. See the `data_description.md` file for an extended description of the data.

## Evaluation

The evaluation will be done with two members of the Motors team and consists of two parts:

1. You will give a demo of your solution. Feel free to mention the factors you considered when designing your approach as well as any interesting choices you made. There is no time constraint on this part but we expect this to take anywhere from 10 to 30 minutes.
1. A discussion on your approach as well as broader questions with your interviewers.

Your solution will not be compared or scored to any existing solution. We care about your reasoning behind your work; we understand that developing a full-fledged dbt project will take substantial time. So please make sure that you do not get stuck in premature optimisation.

We care about your ability to create data driven solutions that are useful for end users. In the end we care about creating sustainable solutions for our data consumers that will help them improve the organisation in the short and longer term.

Please share the URL to your GitHub repository, at least 12 hours in advance of your interview, with [Rhys.Shipman@motors.co.uk](mailto:Rhys.Shipman@motors.co.uk).

## Questions

In case of questions or uncertainty you can send e-mail to [Rhys.Shipman@motors.co.uk](mailto:Rhys.Shipman@motors.co.uk).
