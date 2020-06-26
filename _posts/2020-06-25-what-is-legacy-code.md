---
layout: post
title: What is Legacy Code?
categories: opinion
tags: opinion programming
stopwords: Rik dzil Feathers's else's unserious greybeard ness
last_modified:
original_url:
---

What is "legacy" code? Or, what makes some code "legacy" and other code not? I looked for a good definition, and I didn't find one that made any sense. Many people seemed to have not considered their definition before choosing it.

A label is only good in so far as it distinguishes one thing from another. If everything is the same, you don't need a label. It's once we start to categorize things that we recognize finer distinctions and make finer labels.

Consider the English word "apple". You think you know what that is, and you and I probably would agree on something's apple-ness if a piece of fruit were placed in front of us. But, English's use of "apple" is much narrower than its beginnings. It used to mean any fruit, aside from berries. Some fruits then needed additional disambiguation—"pineapple" for instance, or "apples of paradise" (bananas), or "golden apples" (oranges).

Philosophy has three parts, roughly, that help us observe the world, figure out what we see, then make decisions based on that. When we are talking about what an idea means and consequence that idea has, we are essentially in the realm of philosophy:

* What do I know?
* How do I know it?
* How should I act, knowing that?

These are different questions than those of the realm of religion (even apart from spirituality), where you might ask those questions in the reverse order. And, I think technical people tend to act religiously in order to strengthen their tribe. That is, the answers they provide serve more to distinguish themselves than elucidate ideas.

## The unserious answers

I do have my own answer about legacy code, but let's first look at the silliness I found.

### The flippant varieties

StackOverflow has several answers for [What makes code legacy?](https://stackoverflow.com/q/479596/2766176). Some of them aren't that serious and belie the hobbyist nature of the person giving the answer:

* Code that uses tools that aren't "cool" anymore
* Code you didn't write
* Code that you don't understand anymore
* Code written last week
* Code that you'd rather replace

These are hardly worth dispelling, but in a later section I lay out the logic that easily dispatches them. In short, that says more about the practitioner than the product. This is that religiosity; surely *I* would never write such code, but other people do.

### The less flippant

Some of the StackOverflow answers are slightly more useful, but are markers of time rather than quality, difficulty, or something else:

* Code that uses an older paradigm
* Code running on an unsupported platform

Software Engineering StackExchange site's [When is code "legacy"?](https://softwareengineering.stackexchange.com/q/94007/103630) has much the same flippant mix of answers, but [one thoughtful community wiki answer](https://softwareengineering.stackexchange.com/a/94207/103630).

> The fact that it is still used in production is precisely what makes it legacy.

> Legacy means that it is still in use and works fine, but incorporates designs or techniques that are no longer in common use.

> In some cases there's nothing wrong with legacy code. It's not a bad word. Legacy code/systems are not Evil. They've just collected some dust - sometimes a little, sometimes a lot.

That answer is ultimately unsatisfying because it presents contradictory definitions that skirt the issue. The first definition says that it's legacy if its used in production, but the second then qualifies that. That last statement equivocates a bit.

### Michael C. Feathers

Micheal C. Feathers perhaps has the most popular answer. It's glib, but not very useful. In [Working Effectively with Legacy Code](https://amzn.to/31iOY0g)'s preface, he writes:

> In the industry, legacy code is often used as a slang term for difficult-to-change code that we don’t understand. But over years of working with teams, helping them get past serious code problems, I’ve arrived at a different definition.

> To me, legacy code is simply code without tests. I’ve gotten some grief for this definition. What do tests have to do with whether code is bad? To me, the answer is straightforward, and it is a point that I elaborate throughout the book:

In the first paragraph, you have to assume quite a bit to accept that definition. It begs the question that the people are competent practitioners not only in tools applied to the problem, but also the domain of the problem. I reject that assumption. Difficult-to-change and "don't understand" aren't properties of code. They are properties of developers and institutions. It's very easy to change code; it's merely difficult to get it to what you want instead of whatever it does now. That's a bit flippant, but I'll come back to that.

What's understandable? What does that even mean? The best definition of "understandable" in this context is that a skilled practitioner of the same tools in the same domain recognizes and can work within the existing design. Basically, they can look at the code and know what's going on, then create new code in the same way. There is no judgment of good or bad there.

Here's the rub, though. Not many people are skilled practitioners. Many people in the software industry get by with cut-and-paste and luck. Not only do they not understand their tools, they don't care to. It's the same with their problem domain. How many programmers do you know who would talk to a customer (or co-worker) to see what they need? Maybe you know some, but when you consider all of the programmers whom you have met, how often is that true?

Now consider the counter case. You have a talented but unskilled junior programmer who is starting to learn their tools and is new to the problem domain. They have the aptitude but not the experienced. They are motivated to learn. Does that make the enterprise code they see in source control any easier to understand? Does that junior programmer's comfort level change the quality of the code?

But what about the burnt-out greybeard sitting next them who knows every corner of the code, has been with the same company for a couple decades, and is friends with people in the non-tech departments. They are well-versed in the problem domain and know their tools. They can fix any problem that comes up in the same day. Is that code difficult to understand or difficult to change? Not for them it isn't. Does that make it not legacy?

Feathers' second definition is practically worthless (but not to worry because he eventually gets it right). As a label, how is "without tests" helpful?

Let's suppose that I start a completely new software project today. It's a prototype for something I'm thinking about but can't quite envision working just yet. I write a simple program and run it. There are no tests. By his definition, this is legacy code. But, the code is neither difficult to change or hard to understand. There are no users, no stakeholders, and I've written it to be simple, by definition. I can make it do anything I like. Does your idea of "legacy" overlap with this situation? Not at all.

Consider those silly comments from before, such as "code you wrote last week". Is that a function of the code or that you can't remember what you were trying to do. Could you even explain it your task apart from the code? If you can, why didn't you effectively translate that into code? Why is it the code's fault?

Now, I said I've written a simple program. Is it understandable? The best definition of "understandable" in this context is that a skilled practitioner of the same tools in the same domain recognizes and can extend the design and architecture. Basically, they can look at the code and know what's going on, why I did it, and how they can keep going.

I don't think "legacy" was the term Feathers really wanted for his book, even though I think it's the right marketing choice. "Intractable" wouldn't sell as many books. A few paragraphs prior to his own definition, he writes:

> Legacy code is code that we’ve gotten from someone else. Maybe our company acquired code from another company; maybe people on the original team moved on to other projects. Legacy code is somebody else's code.

This is more a symptom than a property though, and that definition is as easy to dispatch as the prior ones. Is it legacy because it changes owners? Does that mean when someone leaves their job and you work on their project, it magically shifted to being legacy despite any other factor? But, he quickly does away with that definition:

> That definition of legacy code has nothing to do with who wrote it. Code can degrade in many ways, and many of them have nothing to do with whether the code came from another team.

Granted, Feathers's statement about tests is not as strong as it appears. I suspect many people who repeat his one sentence have never read his book. He later gives a much better description when he uses the metaphor of surgery:

> [W]hat we really need to do is take the patient as he is, fix what’s wrong, and move him to a healthier state.

Think on that for a minute. Is that a useful distinction worthy of a label? Code that we can't substantially redesign, but fix what's wrong and do slightly better? I think it is. That idea is the undercurrent of his entire book. I'm come back to that in the end of this post.

The rest of his book is very much like [Design Patterns](https://amzn.to/3fXZQo9), where he presents situations and constraints, then possible solutions built on those. He even gives them names as they do in that book. Don't let my quibbling over "legacy" detract from that; once you understand what he means by it, it doesn't matter if I agree with it.

### The saga of Text Template

Mark Jason Dominus is the original author of the Perl module [Text::Template](https://metacpan.org/pod/Text::Template), a no-frills, small template processing module. I've used it in tiny projects where I didn't need anything fancier. He's also the author of perhaps the best book ever written about the language, [Higher Order Perl](https://hop.perl.plover.com). Talk to him and he's likely so casually drop references about ML into the conversation. And then a week later you think "Holy shit! My whole life has been wrong!"

In his [Twelve Views of Mark Jason Dominus](https://perl.plover.com/yak/12views/samples/notes.html) talk, he writes that his modest module has reached its goal, but that was not enough.

> Anyway, the module quickly stabilized. ... Since the module was perfect, there was no need to upload new versions of it to CPAN.

> But then I started to get disturbing emails. ``Hi, I notice you have not updated Text::Template for nine months. Are you still maintaining it?''

> People seem to think that all software requires new features or frequent bug fixes. Apparently, the idea of software that doesn't get updated because it's finished is inconceivable.

I don't think that's an unreasonable idea considering how much software is unfit for purpose even the same day it's public. But, the Perl community through [CPAN Testers](https://www.cpantesters.org) tests all modules against every version of Perl. It's very easy to find out if something still passes its tests. That's different from works, but hold onto that for a moment.

Curiously the module is now maintained by another author, who immediately set about rejiggering everything for a Perl authoring system known as [Dist::Zilla](http://dzil.org). At it's heart, this is a framework that regenerates much of the boilerplate of a Perl distribution for you. Rik SIGNES created it because he maintains literally hundreds of Perl modules (many of them very good, a higher average than most, including me). If he wanted to change his LICENSE file, he didn't want to go through every repo to do it. When he built the module, all that stuff would happen. I have a different approach to that problem, but that's beside the point.

The new maintainer did a lot of work to move mjd's code into a new framework that didn't do anything to improve the user experience. Since then, Text::Template has had very slight changes to handle new warnings and a few other things. Some of the code style changed, the documentation was adjusted, and so on. But, most of the work was taking what worked and tying it to a particular fad framework.

This is the sort of activity I imagine occurs with most people who complaining about "legacy". They move code from the state it's in into the framework they want to work it. Instead of adapting to the job, they adapt to the job to them. The dual work of learning code and learning a new environment is often too large of a bite for someone with moderate experience and limited time.

As a side note, I don't supply patches to any code that uses Dist::Zilla. First, it's often difficult to patch distribution files that don't show up in the repo (having been generated from some far away plugin). Second, I don't send patches if I can't run the tests. I usually give up after about 20 minutes of Dist::Zilla trying to install half of CPAN. Sometime I'll report issues, but often I'll just find some other module to do it. I'm sure other casual, drive-by contributions are similarly stymied. I'll come back to this when I talk about tests.

### The dictionary

Dictionaries tend to be a hazardous place to find definitions, even when they do strive to be descriptive. Here are a few.

[Oxford Dictionaries](https://www.lexico.com/en/definition/legacy)

> denoting or relating to software or hardware that has been superseded but is difficult to replace because of its wide use.

[Dictionary.com](https://www.dictionary.com/browse/legacy?s=t)

> of or relating to old or outdated computer hardware, software, or data that, while still functional, does not work well with up-to-date systems.

[Merriam Webster](https://www.merriam-webster.com/dictionary/legacy)

> of, relating to, associated with, or carried over from an earlier time, technology, business, etc.

Oxford Dictionaries has a restrictive clause that requires the software to have been superseded. That doesn't quite square with other definitions of legacy which imply a continuation of something, such as a deceased rich person's continued influence through a foundation.

Dictionary.com requires the software to not work well with up to date systems. That's a bit more tricky. What does up to date mean? Have you updated your Linux box today, even though you did so yesterday? What if you have a planned upgrade cycle of several months so you aren't constantly responding to the whims of your platform, but save that for part of the business cycle that allows for some breathing room? How long can that period be? Is this like a new car, which loses most of its value when you drive it off the lot? What if it has always been the same people involved?

Merriam Webster places their definition in time. It doesn't remark on the quality or appropriateness of the idea or object.

## Are tests any good?

Remember that the main assertion from Feathers was that legacy code is code without "tests". He admits it's a facile description suited to his purpose. But, let's go there. I think tests actually create legacy code. Some of the major code that runs the world has tests, and those are legacy too.

I've lived and worked through many testing fads. Test Driven Development was a big one and I half used it. People forget that your testing strategy has to be designed for your process. If an aerospace company hands me a completely written specification, I can write the tests first because I already know the expected outputs. I have no say in that. However, if I'm a startup with no idea where I might end up, I can start with tests.

So here's the problem. I offer to you the idea that tests do more to lock in code than the code does itself. People who put in a significant amount of time testing their codebase are loathe to change the tests. Consider the monstrosity that is RSpec. I'll simply point you to Joe Ferris's [Let's Not](https://thoughtbot.com/blog/lets-not) who comes up with this code:

{% highlight ruby %}
it "adds each attribute to the evaluator" do
  attribute = stub_attribute(:attribute) { 1 }
  evaluator = define_evaluator(attributes: [attribute])

  evaluator.attribute.should eq 1
end

it "evaluates the block in the context of the evaluator" do
  dependency_attribute = stub_attribute(:dependency) { 1 }
  attribute = stub_attribute(:attribute) { dependency + 1 }
  evaluator = define_evaluator(attributes: [dependency_attribute, attribute])

  expect(evaluator.attribute).to eq 2
end

def define_evaluator(arguments = {})
  evaluator_class = define_evaluator_class(arguments)
  evaluator_class.new(FactoryGirl::Strategy::Null)
end

def define_evaluator_class(arguments = {})
  evaluator_class_definer = FactoryGirl::EvaluatorClassDefiner.new(
    arguments[:attributes] || [],
    arguments[:parent_class] || FactoryGirl::Evaluator
  )
  evaluator_class_definer.evaluator_class
end

def stub_attribute(name = :attribute, &value)
  value ||= -> {}
  stub(name.to_s, name: name.to_sym, to_proc: value)
end
{% endhighlight %}

Does any of this make any sense? How far away from the problem is this sort of code? How does the proliferation of abstraction layers give us any more confidence that the target of the tests is acting appropriately and that failures aren't a problem with the tests themselves? This is essentially a whole other codebase that you now have to maintain. Are you going to completely change these tests to allow your code to go in a different direction?

I don't particularly like RSpec because I know I'm doing a lot of work to allow for features I don't want to use. Information density is very low partly because of Ruby's syntax, but mostly because the "DSL" is neither domain nor specific. Having said that, [Effective Testing with RSpec 3](https://amzn.to/2ZdA8W7) is a good book. The best way to deal with it is to accept its metaphor and go with it, which is also the subject of a different post.

Once you've tested the application completely with close to about 90% statement, branch, and conditional coverage, you're unlikely to make drastic changes that break the tests. Not only will you suffer from the [sunk cost fallacy](https://www.behavioraleconomics.com/resources/mini-encyclopedia-of-be/sunk-cost-fallacy/), but you simply don't have that time to do that much work even if you wanted to. You might have improved your code to the point that it does what it should, but now you are stuck. And, you have much more code to change. Even if you wanted to change, you just spent all of your extra time making tests. Those tests further locked-in that codebase and take away even more of your time in ongoing maintenance.

## So who wins?

So, if Feathers says that legacy code is code without tests and I say it's code with tests, who's correct? And this is where we come back to the labels and why they matter. There has to be a useful distinction between the thing that gets the label and the thing that doesn't. I think there's a way that both Feathers and I are right because there exists an overlap. Both of our situations beg the question that **there's little political or economic will to drastically change the code**.

This is not necessarily bad, and it's not a property of the code itself. It's something we assign to code based on externalities. It's a mix of art (politics) and science (economics), but at its heart, it's also an existential question of survival.

First, consider the political will to do something. I've found that this is largely unrelated to the merit of that something. Politics is the art of compromises, and those competing factors often have nothing to do with code quality. The problem however, it's rare that the decisions about the quality of the code because that's not why the code exists.

Second, there's the will to commit or consume resources to any venture. Economics is, after all, the science of scarce resources. Given an infinite supply of qualified and competent programmers, an unlimited budget, and access to all the fancy hardware you desire, you can completely rewrite whatever you want to get new code that's as beautiful and performant as you desire.

But, what I hear from almost all of my friends hiring programmers, no matter the language, is that hundreds of résumés lead to a handful of interviews. In that handful of interviews, it's slim pickings. This is a topic for a different post, but if you have to advertise for a job and accept whoever shows up, you're already on the losing end. I've almost always hired people away from situations that they hadn't considered leaving. And now you can't hire anyone away from Google; those people just disappear from the world.

But let's say you have a qualified and competent team of the size you like. That's likely five to seven people, which is about the limit of the span of control for a single manager. You have your dream team. What happens during the typical work week? I often hear from programmers that they get about two hours of work done a day (the two hours before everyone shows up or after everyone leaves). The other 30 hours out of the typical 40 hour work week are filled with business nonsense. Indeed, I just counseled one of my friends to simply stop going to meetings that had no agenda or stated desired outcome. Welcome to Scientific Management and its consequences.

Consider this drawing of Iron Man in different time constraints. In the most generous constraint, the artist uses several different tools. He starts with a sketch that you won't see in the final product, employs ink and more pencil, and even a Sharpie. There's more time to put the subject in context. In the others, it's mostly just the Sharpie:

<iframe width="560" height="315" src="https://www.youtube.com/embed/6-ksI6FWST4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

But, let's concede that you get 40 hours a week to do real work because your manager shields the team from bullshit, you aren't in an open office plan, and everyone else does their work on time too. Still, work expands to fill all available time. If you need it by friday, you get it on friday (one of my rules of programming is don't deliver before you are forced to). With 10 hours a week you get the bare minimum that someone will accept. With 40 hours maybe you get some tests, code comments, and a couple of versions of the starting idea.

So, you get have all that time to make progress on your project. Where are you a year later? You've spent no time considering larger technical issues. Should you use that new AWS service or stick with what you have? Migrate from Python 2 to 3? Figure out that new JavaScript UI thing? Convert to microservices? Convert back from microservices? You've devoted maximum time to improving your project and a year later everything you've done is out-of-date. Is your project legacy now?

You could go through the same logic with finances. The more people you hire, the more people you have to hire to manage the people you are hiring. The average contribution of an employee to the direct benefit of consumers drops precipitously while your cost per unit of value goes through the roof. Does that make your project legacy?

Back up a moment. You have various resources and you think you have some goal. Your team is working toward that stated goal. But, that goal isn't the company's real goal. The first goal of every organization is to continue to exist. As part of that, organizations give certain people the power to make decisions, usually through a board of directors that approve a management team. The fate of your code depends on those people to make decisions.

Not only that, within an organization, individuals have their own goals. Many want to keep getting paid. Some want to keep moving up the ladder. Many of those goals are at odds with the company's mission. Stop paying those people or tell them they won't be promoted and see if they still believe in the company. Try this sometime. Give all of your developers a $10,000 bonus at the end of the year, including the asshole who never delivers but also breaks the build every friday. But give $9,750 to the best developer. It's barely any money at all, but I known people to start sending out feelers over it.

And that brings us back to legacy code. **It's existing code that the company accepts because the decision makers think it is the best course to allow the company to continue to exist**. There's little political or economic will to drastically change the code. That will is derives from the wants and desires of people who never touch or see the code as well as the company's revealed preferences to tolerate that.

This definition does not rely on the debates about hardware, programming fads, tests or no tests, and any other second-order symptoms. It doesn't depend on understandability or difficulty, but I think it still gets to the heart of the issue.






