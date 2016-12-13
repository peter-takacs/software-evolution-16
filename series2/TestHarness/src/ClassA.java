/**
 * 
 * Test Ignore multiline.
 * @author Peter
 *
 */
public class TestClassA {
	
	// Test ignore comments
	// Test ignore empty lines
	
	private int propertyOne;
	
	private int propertyTwo;
	private int propertyThree;
	
	
	// Test ignore indentation
	public void TestMethod()
	{
		/*
		 * Test ignore other multiline
		 */
		int variableA;
		for (int i=0; i<3; i++)
		{
			System.out.println(i);
		}
	}
}