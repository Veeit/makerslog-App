//
//  DataSecurity.swift
//  iOS
//
//  Created by Veit Progl on 25.02.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct DataSecurity: View {
	//swiftlint:disable all
     var body: some View {
		ScrollView() {
			VStack(alignment: .leading) {
				Group() {
					Text("1. data protection at a glance").font(Font.title).bold()
					Text("""
						The following notes provide a simple overview of what happens to your personal data when you use my app. Personal data are all data with which you can be personally identified. For detailed information on the subject of data protection, please refer to our data protection declaration listed below this text.
						""").multilineTextAlignment(.leading)
					Text("Data acquisition").font(Font.title).bold().padding([.top], 10)
					Text("Who is responsible for data collection on this website?").bold().padding([.top], 10)
					Text("The data processing on this app is carried out by the app operator. You can find his contact details in the imprint of this app.")
					Text("How do we collect your data?").bold().padding([.top], 10)
					Text("""
						On the one hand, your data is collected when you provide it to us. This may be data that you enter in a contact form, for example.
						Other data is automatically collected by our IT systems when you open the app. These are mainly technical data (e.g. App user count, operating system or shaw onbording screen). This data is collected automatically as soon as you enter open the app.
						The add log / discussion  data is not saved be us, we just send it to makerlog. We just save your login token (not the login data (user name and user password!)) on your device.
						If the app crahses and you can send us a creash report, we get ther detailed information about where it creahsed, device information and time. This data can not be traced back to you.
						In general we don't save any personal data that can be be traced back to you on our server, we just send it to makerlog to save it. You shoud read the makerlog privicy policy and contact the operator of makerlog if you have a problem with it.
						Link to makerlog privicy policy:
						""").multilineTextAlignment(.leading)
					Button(action: {
						self.openMakerlogAbout()
					}) {
						Text("https://getmakerlog.com/about")
					}
					Text("Analysis tools and third-party tools").bold().padding([.top], 10)
					Text("""
						When you open our app, your use behaviour can be statistically evaluated. This is mainly done with so-called analysis programs. The analysis of your user behaviour is usually anonymous; the user cannot be traced back to you.
						You can object to this analysis or prevent it by not using certain tools. You can find detailed information about these tools and about your options to object to them in the following data protection declaration.
						""")
				}
				Group() {
					Text("2. general notes and compulsory information").font(Font.title).bold().padding([.top])
					Text("Data protection").bold().padding([.top], 10)
					Text("""
						The operators of these app take the protection of your personal data very seriously. We treat your personal data confidentially and according to the legal data protection regulations as well as this privacy policy.
						When you use this app, various personal data is collected. Personal data is data with which you can be personally identified. This privacy policy explains what data we collect and what we use it for. It also explains how and for what purpose this is done.
						We would like to point out that data transmission on the Internet (e.g. communication by e-mail) can have security gaps. A complete protection of data against access by third parties is not possible.
						""").multilineTextAlignment(.leading)
					Text("Revocation of your consent to data processing").bold().padding([.top], 10)
					Text("""
						Many data processing operations are only possible with your express consent. You can revoke a previously given consent at any time. For this purpose an informal notification by e-mail to us is sufficient. The legality of the data processing carried out up to the time of revocation remains unaffected by the revocation.
						""").multilineTextAlignment(.leading)
	
					Text("Right to object to data collection in special cases and to direct advertising (Art. 21 DPA)").bold().padding([.top], 10)
					Text("""
					If the data processing is carried out on the basis of Article 6 paragraph 1 letter e or f DPA, you have the right to object to the processing of your personal data at any time for reasons arising from your particular situation; this also applies to profiling based on these provisions. You will find the respective legal basis on which processing is based in this Data Protection Declaration. If you object, we will no longer process your personal data concerned unless we can prove that there are compelling reasons for processing which are worthy of protection and which outweigh your interests, rights and freedoms, or unless the processing serves to assert, exercise or defend legal claims (objection according to Art. 21 Para. 1 DSGVO).
					If your personal data are processed for the purpose of direct marketing, you have the right to object at any time to the processing of personal data concerning you for the purpose of such marketing, including profiling, insofar as it is connected with such direct marketing. If you object, your personal data will subsequently no longer be used for the purpose of direct advertising (objection under Art. 21 para. 2 DSGVO).
					""")
					Text("Right of appeal to the competent supervisory authority").bold().padding([.top], 10)
					Text("""
						In the event of infringements of the DSGVO, those concerned have a right of appeal to a supervisory authority, in particular in the Member State of their habitual residence, place of work or the place where the alleged infringement was committed. This right of appeal is without prejudice to other administrative or judicial remedies.
						""")
				}
				Group() {
					Text("Right to data portability").bold().padding([.top], 10)
					Text("""
						You have the right to have data which we process automatically on the basis of your consent or in fulfilment of a contract handed over to you or to a third party in a common, machine-readable format. If you request the direct transfer of the data to another responsible party, this will only take place to the extent that it is technically feasible.
						""")
				}
				Group() {
					Text("Right to restrict processing").bold().padding([.top], 10)
					Text("""
					You have the right to request the restriction of the processing of your personal data. To do so, you can contact us at any time at the address given in the imprint. The right to restrict processing exists in the following cases:
					1. If you dispute the accuracy of your personal data stored with us, we usually need time to verify this. For the duration of the review, you have the right to demand the restriction of the processing of your personal data.
					2. If the processing of your personal data was/is unlawful, you may request the restriction of data processing instead of deletion.
					3. If we no longer need your personal data, but you need them in order to exercise, defend or assert legal claims, you have the right to request restriction of the processing of your personal data instead of deletion.
					4. If you have lodged an objection in accordance with Art. 21 Paragraph 1 DSGVO, a balance must be struck between your interests and ours. As long as it has not yet been determined whose interests outweigh the interests of both parties, you have the right to demand that the processing of your personal data be restricted.
					If you have restricted the processing of your personal data, these data - apart from their storage - may only be processed with your consent or for the assertion, exercise or defence of legal claims or for the protection of the rights of another natural or legal person or for reasons of an important public interest of the European Union or a Member State.
					""")
				}
				Spacer()
			}
			.navigationBarTitle("Imprint")
			.padding([.leading, .trailing])
		}
	}
	func openMakerlogAbout() {
		if let url = URL(string: "https://getmakerlog.com/about") {
			UIApplication.shared.open(url)
		}
	}
}

struct DataSecurity_Previews: PreviewProvider {
    static var previews: some View {
        DataSecurity()
    }
}
