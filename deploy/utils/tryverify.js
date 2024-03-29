module.exports = async (contract, args, file) => {
    try {
      await run("verify:verify", {
        contract: file,
        address: contract,
        constructorArguments: args,
        optimizer: true
      });
    } catch (e) {
      console.log(e);
      console.log(`${e.name} - ${e.message}`);
    }
  };
