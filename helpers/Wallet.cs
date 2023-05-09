using Godot;
using System;
using Newtonsoft;
using EdjCase.ICP.Agent.Agents;
using EdjCase.ICP.Agent.Auth;
using EdjCase.ICP.Agent.Identity;
using EdjCase.ICP.Candid.Models;
using HDWallet.Core;
using HDWallet.Ed25519.Sample;
using NBitcoin;

public partial class Wallet :Node
{
	public String createWallet()
		{
			Mnemonic mnemo = new Mnemonic(Wordlist.English, WordCount.Twelve);
			GD.Print(mnemo.ToString());
			IHDWallet<SampleWallet> _wallet = new TestHDWalletEd25519(mnemonic: mnemo.ToString(), "");
			SampleWallet wallet = _wallet.GetAccount(0).GetExternalWallet(0);
			ED25519PublicKey publicKey = new ED25519PublicKey(wallet.PublicKeyBytes);
			var identity = new ED25519Identity(publicKey,wallet.PrivateKeyBytes);
			var principal = identity.GetPrincipal();
			GD.Print(principal.ToString());
			return principal.ToString();
			
			/*string method = "add";
			Principal authCanisterId = Principal.FromText("m54ii-kaaaa-aaaan-qdq4q-cai");
			QueryResponse response = await agent.QueryAsync(authCanisterId, method, principal);*/
		}
}	
	
