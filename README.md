<html>

<body lang=EN-US style='tab-interval:.5in'>

<div class=WordSection1>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:20.0pt;mso-bidi-font-size:12.0pt;line-height:107%'>Trigger
Best Practices<o:p></o:p></span></b></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:14.0pt;mso-bidi-font-size:12.0pt;line-height:107%'>One Trigger
<span class=GramE>Per</span> Object<o:p></o:p></span></b></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>A single
Apex Trigger is all you need for one particular object. If you develop multiple
Triggers for a single object, you have no way of controlling the order of
execution if those Triggers can run in the same contexts. Many times, the order
of execution doesn’t matter but when it does matter, it’s nearly impossible to
maintain proper flow control. A single Trigger can handle all possible
combinations of Trigger contexts which are:<o:p></o:p></span></p>

<p class=MsoNormal><span class=GramE><span style='font-size:12.0pt;line-height:
107%'>before</span></span><span style='font-size:12.0pt;line-height:107%'>
insert<br>
after insert<br>
before update<br>
after update<br>
before delete<br>
after delete<br>
after undelete<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>So as a best
practice, create one Trigger per object and let it handle all of the contexts
that you need. Here is an example of a Trigger that implements all possible
contexts:<o:p></o:p></span></p>

<p class=MsoNormal><span class=GramE><span style='font-size:12.0pt;line-height:
107%'>trigger</span></span><span style='font-size:12.0pt;line-height:107%'> <span
class=SpellE>trgContact</span> on Contact (before insert, before update, before
<span class=SpellE>delete,after</span> insert, after update, after delete,
after undelete) {<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>  </span><span style='mso-tab-count:1'>          </span>//
trigger body<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:14.0pt;mso-bidi-font-size:12.0pt;line-height:107%'>Logic-less
Triggers<o:p></o:p></span></b></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>Another
widely-recognized best practice is to make your Triggers logic-less. That
means, the role of the Trigger is just to delegate the logic responsibilities
to some other handler class. There are many reasons to do this. For one,
testing a Trigger is difficult if all of the application logic is in the
trigger itself. If you write methods in your Triggers, those can’t be exposed
for test purposes. You also can’t expose logic to be re-used anywhere else in
your org. Good old OO principles tell us that this is a bad practice. And to
top it all off, cramming all of your logic into a Trigger is going to make for
a mess one day. To remedy this scenario, just create a handler class and let
your Trigger delegate to it. Here is an example:<o:p></o:p></span></p>

<p class=MsoNormal><span class=GramE><span style='font-size:12.0pt;line-height:
107%'>trigger</span></span><span style='font-size:12.0pt;line-height:107%'> <span
class=SpellE>trgContact</span> on Contact (after insert) {<o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:.5in'><span class=SpellE><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>ContactTriggerHandler.handleAfterInsert</span></span></span><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>(</span></span><span
class=SpellE><span style='font-size:12.0pt;line-height:107%'>Trigger.new</span></span><span
style='font-size:12.0pt;line-height:107%'>);<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>And the handler
class:<o:p></o:p></span></p>

<p class=MsoNormal><span class=GramE><span style='font-size:12.0pt;line-height:
107%'>public</span></span><span style='font-size:12.0pt;line-height:107%'>
class <span class=SpellE>ContactTriggerHandler</span> {<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span class=GramE><span
style='font-size:12.0pt;line-height:107%'>public</span></span><span
style='font-size:12.0pt;line-height:107%'> static void <span class=SpellE>handleAfterInsert</span>(List
<span class=SpellE>opps</span>) {<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in;text-indent:.5in'><span
style='font-size:12.0pt;line-height:107%'>// handler logic<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:14.0pt;mso-bidi-font-size:12.0pt;line-height:107%'>Context-Specific
Handler Methods<o:p></o:p></span></b></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>One
best-practice is to create context-specific handler methods in my Trigger
handlers. In the above example, you’ll see that I’ve created a specific handler
method just for after insert. If I were to implement new logic that ran on
after update, I’d simply add a new handler method for it. Again, this handler
method would be in the handler class, and not the Trigger. In this case, I
might add some very light routing logic into the Trigger itself just so that
the correct handler method is invoked:<o:p></o:p></span></p>

<p class=MsoNormal><span class=GramE><span style='font-size:12.0pt;line-height:
107%'>trigger</span></span><span style='font-size:12.0pt;line-height:107%'> <span
class=SpellE>trgContact</span> on Contact(after insert, after update) {<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'> </span><span class=GramE>if(</span><span
class=SpellE>Trigger.isAfter</span> &amp;&amp; <span class=SpellE>Trigger.isInsert</span>)
{<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'> </span><span
style='mso-tab-count:1'>           </span><span class=SpellE><span class=GramE>ContactTriggerHandler.handleAfterInsert</span></span><span
class=GramE>(</span><span class=SpellE>Trigger.new</span>);<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'> </span>} <o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span class=GramE><span
style='font-size:12.0pt;line-height:107%'>else</span></span><span
style='font-size:12.0pt;line-height:107%'> if(<span class=SpellE>Trigger.isAfter</span>
&amp;&amp; <span class=SpellE>Trigger.isUpdate</span>) {<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'> </span><span
style='mso-tab-count:1'>           </span><span class=SpellE><span class=GramE>ContactTriggerHandler.handleAfterInsert</span></span><span
class=GramE>(</span><span class=SpellE>Trigger.new</span>, <span class=SpellE>Trigger.old</span>);<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'> </span>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:14.0pt;mso-bidi-font-size:12.0pt;line-height:107%'>Why Use a
Framework?<o:p></o:p></span></b></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>Flow Control<br>
Recursion Detection and Prevention<br>
Centralize Enable/Disable of Triggers<br>
Simplify testing and maintenance of your application logic<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:14.0pt;mso-bidi-font-size:12.0pt;line-height:107%'>Basic
Implementation<o:p></o:p></span></b></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:12.0pt;line-height:107%'>Trigger<o:p></o:p></span></b></p>

<p class=MsoNormal><span class=GramE><span style='font-size:12.0pt;line-height:
107%'>trigger</span></span><span style='font-size:12.0pt;line-height:107%'> <span
class=SpellE>trgContact</span> on Contact(after insert, after update, after
delete, after undelete) {<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>  </span><span class=GramE>new</span> <span
class=SpellE>ContactTriggerHandler</span> ().run();<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:12.0pt;line-height:107%'>And here is the handler class we will
create:<o:p></o:p></span></b></p>

<p class=MsoNormal><span class=GramE><span style='font-size:12.0pt;line-height:
107%'>public</span></span><span style='font-size:12.0pt;line-height:107%'>
class <span class=SpellE>ContactTriggerHandler</span> extends <span
class=SpellE>TriggerHandler</span> {<o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:.5in'><span class=GramE><span
style='font-size:12.0pt;line-height:107%'>public</span></span><span
style='font-size:12.0pt;line-height:107%'> <span class=SpellE>OpportunityTriggerHandler</span>()
{}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>  </span><span style='mso-tab-count:1'>          </span>/*
context overrides */<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>  </span><span style='mso-tab-count:1'>          </span><span
class=GramE>protected</span> void override <span class=SpellE>beforeUpdate</span>()
{<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in;text-indent:.5in'><span
class=SpellE><span class=GramE><span style='font-size:12.0pt;line-height:107%'>setLostOppsToZero</span></span></span><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>(</span></span><span
style='font-size:12.0pt;line-height:107%'>);<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>  </span><span style='mso-tab-count:1'>          </span>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>  </span><span style='mso-tab-count:1'>          </span>/*
private methods */<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>  </span><span style='mso-tab-count:1'>          </span><span
class=GramE>private</span> void <span class=SpellE>setLostOppsToZero</span>(List)
{<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>    </span><span style='mso-tab-count:2'>                    </span><span
class=GramE>for(</span>Opportunity o : (List&lt;Opportunity&gt;) <span
class=SpellE>Trigger.new</span>) {<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>      </span><span style='mso-tab-count:3'>                              </span><span
class=GramE>if(</span><span class=SpellE>o.StageName</span> == 'Closed Lost'
&amp;&amp; <span class=SpellE>o.Amount</span> &gt; 0) {<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>        </span><span style='mso-tab-count:4'>                                        </span><span
class=SpellE>o.Amount</span> = 0;<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>      </span><span style='mso-tab-count:3'>                              </span>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>   </span><span style='mso-tab-count:1'>         </span><span
style='mso-spacerun:yes'> </span><span style='mso-tab-count:1'>           </span>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>  </span><span style='mso-tab-count:1'>          </span>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><i style='mso-bidi-font-style:normal'><span
style='font-size:12.0pt;line-height:107%'>**An example Trigger and Handler
Class is enclosed that implements all the trigger context.<o:p></o:p></span></i></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span class=GramE><span style='font-size:12.0pt;line-height:
107%'>public</span></span><span style='font-size:12.0pt;line-height:107%'>
class <span class=SpellE>ContactTriggerHandler</span> extends <span
class=SpellE>TriggerHandler</span> {<o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:.5in'><span class=GramE><span
style='font-size:12.0pt;line-height:107%'>public</span></span><span
style='font-size:12.0pt;line-height:107%'> <span class=SpellE>ContactTriggerHandler</span>
() {}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>  </span><span style='mso-tab-count:1'>          </span>/*
context overrides */<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'>  </span><span style='mso-tab-count:1'>          </span><span
class=GramE>protected</span> void override <span class=SpellE>beforeUpdate</span>()
{<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in;text-indent:.5in'><span
class=SpellE><span class=GramE><span style='font-size:12.0pt;line-height:107%'>setSomeValues</span></span></span><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>(</span></span><span
style='font-size:12.0pt;line-height:107%'>);<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'> </span><span style='mso-spacerun:yes'> </span><span
style='mso-tab-count:1'>          </span>}<o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:.5in'><span class=GramE><span
style='font-size:12.0pt;line-height:107%'>protected</span></span><span
style='font-size:12.0pt;line-height:107%'> void override <span class=SpellE>afterInsert</span>()
{<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in;text-indent:.5in'><span
class=SpellE><span class=GramE><span style='font-size:12.0pt;line-height:107%'>doSomeAfterInsertStuff</span></span></span><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>(</span></span><span
style='font-size:12.0pt;line-height:107%'>);<o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:.5in'><span style='font-size:12.0pt;
line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'> </span><span style='mso-tab-count:1'>           </span><span
class=GramE>protected</span> void override <span class=SpellE>beforeDelete</span>()
{<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><span
style='mso-spacerun:yes'> </span><span style='mso-tab-count:2'>                       </span><span
class=SpellE><span class=GramE>doSomeStuffBeforeDelete</span></span><span
class=GramE>(</span>);<o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:.5in'><span style='font-size:12.0pt;
line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:.5in'><span style='font-size:12.0pt;
line-height:107%'>/* private methods */<o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:.5in'><span class=SpellE><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>setSomeValues</span></span></span><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>(</span></span><span
style='font-size:12.0pt;line-height:107%'>){}<o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:.5in'><span class=SpellE><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>doSomeAfterInsertStuff</span></span></span><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>(</span></span><span
style='font-size:12.0pt;line-height:107%'>){}<o:p></o:p></span></p>

<p class=MsoNormal style='text-indent:.5in'><span class=SpellE><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>doSomeStuffBeforeDelete</span></span></span><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>(</span></span><span
style='font-size:12.0pt;line-height:107%'>){}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>As you can see,
the resulting Trigger handler class is easy to understand and easy to update
when your requirements change.<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>The handler
methods like <span class=SpellE><span class=GramE>afterInsert</span></span><span
class=GramE>(</span>) are defined logic-less and meant to be overridden. If
they aren’t overridden, nothing really happens. Here’s what one of those
methods look like in the <span class=SpellE>TriggerHandler</span> class:<o:p></o:p></span></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:14.0pt;mso-bidi-font-size:12.0pt;line-height:107%'>Recursion
Protection<o:p></o:p></span></b></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>In this
framework, we provide a utility that can prevent a single <span class=SpellE>TriggerHandler</span>
from firing recursively. The implementation is pretty simple and allows you to
set the number of executions per Trigger:<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span class=GramE><span style='font-size:12.0pt;line-height:
107%'>public</span></span><span style='font-size:12.0pt;line-height:107%'>
class <span class=SpellE>ContactTriggerHandler</span> extends <span
class=SpellE>TriggerHandler</span> {<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span class=GramE><span
style='font-size:12.0pt;line-height:107%'>public</span></span><span
style='font-size:12.0pt;line-height:107%'> <span class=SpellE>ContactTriggerHandler</span>
() {<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in;text-indent:.5in'><span
class=SpellE><span class=GramE><span style='font-size:12.0pt;line-height:107%'>this.setMaxLoopCount</span></span></span><span
class=GramE><span style='font-size:12.0pt;line-height:107%'>(</span></span><span
style='font-size:12.0pt;line-height:107%'>1);<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span class=GramE><span
style='font-size:12.0pt;line-height:107%'>public</span></span><span
style='font-size:12.0pt;line-height:107%'> override void <span class=SpellE>afterUpdate</span>()
{<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in;text-indent:.5in'><span
style='font-size:12.0pt;line-height:107%'>List &lt;Contact&gt; con = [SELECT Id
FROM Contact WHERE Id <span class=GramE>IN :<span class=SpellE>Trigger.newMap.keySet</span></span>()];<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in;text-indent:.5in'><span class=GramE><span
style='font-size:12.0pt;line-height:107%'>update</span></span><span
style='font-size:12.0pt;line-height:107%'> con; // this will throw after this
update<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:14.0pt;mso-bidi-font-size:12.0pt;line-height:107%'>A Bypass
API?<o:p></o:p></span></b></p>

<p class=MsoNormal><span class=GramE><span style='font-size:12.0pt;line-height:
107%'>public</span></span><span style='font-size:12.0pt;line-height:107%'>
class <span class=SpellE>ContactTriggerHandler</span> extends <span
class=SpellE>TriggerHandler</span> {<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>  </span><span class=GramE>public</span>
override void <span class=SpellE>afterUpdate</span>() {<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>    </span>Contact con =
[SELECT Id, <span class=SpellE>AccountId</span> FROM Contact WHERE Id <span
class=GramE>IN :<span class=SpellE>Trigger.newMap.keySet</span></span>() LIMIT
1];<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>    </span>Account <span
class=SpellE>acc</span> = [SELECT Id, Name FROM Account WHERE Id <span
class=GramE>= :</span><span class=SpellE>opps.get</span>(0).<span class=SpellE>AccountId</span>];<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>    </span>Case c = new <span
class=GramE>Case(</span>);<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>    </span><span class=SpellE>c.Subject</span>
= 'My Bypassed Case';<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>    </span><span class=SpellE><span
class=GramE>TriggerHandler.bypass</span></span><span class=GramE>(</span>'<span
class=SpellE>CaseTriggerHandler</span>');<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>    </span><span class=GramE>insert</span>
c; // won't invoke the <span class=SpellE>CaseTriggerHandler</span><o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>    </span><span class=SpellE><span
class=GramE>TriggerHandler.clearBypass</span></span><span class=GramE>(</span>'<span
class=SpellE>CaseTriggerHandler</span>');<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>    </span><span class=SpellE>c.Subject</span>
= 'No More Bypass';<o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>    </span><span class=GramE>update</span>
c; // will invoke the <span class=SpellE>CaseTriggerHandler</span><o:p></o:p></span></p>

<p class=MsoNormal style='margin-left:.5in'><span style='font-size:12.0pt;
line-height:107%'><span style='mso-spacerun:yes'>  </span>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>}<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><b style='mso-bidi-font-weight:normal'><span
style='font-size:14.0pt;mso-bidi-font-size:12.0pt;line-height:107%'>On/Off
Switch<o:p></o:p></span></b></p>

<p class=MsoNormal><span style='font-size:12.0pt;line-height:107%'>Every time a
trigger runs the trigger handler framework creates a record for its trigger
Handler under <span class=SpellE>TriggerHandler</span>__c custom setting, To
switch off a specific trigger one just needs to go to the list of custom
settings record and <o:p></o:p></span></p>

</div>

</body>

</html>


More information here : https://developer.salesforce.com/page/Trigger_Frameworks_and_Apex_Trigger_Best_Practices
