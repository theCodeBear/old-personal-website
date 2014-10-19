#include <iostream>
#include <string>
#include <vector>
#include <random>
#include <ctime>
#include <iomanip>
#include <cmath>

using namespace std;


//Global Constant:
const int SIZE = 3; // Number of elements in each row and in each columns of the square encoding matrix


// Asks the user to input the message to encrypt. Stores the message and its length.
void inputMessage(string& message, int& length);

// Standardizes the message to fit into a 3-row Matrix by adding blank spaces at the end of the message if needed to fill up the final column of the matrix.
// Stores the number of columns needed for the message matrix.
void standardizeMessage(int length, int& columns, string& message);

// Fills char_matrix with the message to be encrypted in the form of characters. Outputs the character matrix.
void characterMatrix(vector<vector<char> >& char_matrix, string message, int columns);

// Fills int_matrix with the message converted into their ascii integers. Outputs the integer matrix.
void integerMatrix(vector<vector<double> >& int_matrix, string message, int columns);

// Creates an encoding matrix with randomly generated numbers between 0 and 9)
void encodingMatrix(double encoder[][SIZE], int size);

// Encrypts the integer message matrix by multiplying the coding matrix by the integer message matrix (in that order). Prints out the encrypted message matrix.
void encryptMatrix(vector<vector<double> >& resultantMatrix, vector<vector<double> >& startingMatrix, double coder[][SIZE], int size, int columns);

// Finds the inverse of the encoding matrix. This is the decoding matrix. Prints out the decoding matrix.
void decodingMatrix(double decoder[][3], double encoder[][SIZE], int size);

// Decrypts the integer message matrix by mutliplying the decoding matrix by the integer message matrix (in that order). Prints out the decrypted (same as original) message matrix.
vector<vector<int> > decryptMatrix(vector<vector<double> >& resultantMatrix, vector<vector<double> > startingMatrix, double coder[][SIZE], int size, int columns);

// Converts the integer matrix of the decrypted message to a character matrix. Prints out the final decryped matrix and the decrypted message
void finalMessage(vector<vector<int> > int_matrix, vector<vector<char> > char_matrix, int size, int columns);

int main()
{
	srand(time(0));
	string message;	// message to encode
	int length, columns; // total length of message to encode, and number of columns in the matrix to encode
	double encoder[SIZE][SIZE]; // the 2D integer array representing the encoding matrix.
	double decoder[SIZE][SIZE]; // the 2D double array representing the decoding matrix. This is the inverse of the encoding matrix. Needs to be double for row operations while...
								// ...finding the inverse of the encoder.

	inputMessage(message, length);	// gets message to encrypt as input from user
	standardizeMessage(length, columns, message);	// gets the number of columns of the matrix. fills in the extra spaces in the last column if needed.
	
	// Declaring the vector matrices for the message as a character matrix and for the converted integer matrix of the message.
	vector <vector<char> > char_matrix(3, vector<char>(columns));
	vector <vector<double> > int_matrix(3, vector<double>(columns));	// the 2D vector matrix, 3 rows, number of columns is determined by variable "columns"
	
	characterMatrix(char_matrix, message, columns);	// makes a character matrix out of the message. Outputs the character matrix.
	cin.get();
	integerMatrix(int_matrix, message, columns);	// makes integer matrix out of message
	cin.get();
	encodingMatrix(encoder, SIZE);	// Creating encoding 3x3 matrix
	cin.get();
	
	// Declaring the vector matrix for the encrypted message.
	vector <vector<double> > secrets(3, vector<double>(columns));

	encryptMatrix(secrets, int_matrix, encoder, SIZE, columns);	// Encrypts the integer matrix of the messsage and prints out the encrypted matrix.
	cin.get();
	decodingMatrix(decoder, encoder, SIZE);
	cin.get();

	// Declaring matrices to hold the decrypted message.
	vector <vector<int> > final_int_matrix(3, vector<int>(columns));	// Holds the final message in integer form 
	vector <vector<char> > final_char_matrix(3, vector<char>(columns));	// Holds the final decrypted message, same as the one the user input.

	final_int_matrix = decryptMatrix(int_matrix, secrets, decoder, SIZE, columns);	// Decrypts the integer matrix of the messsage and prints out the decrypted matrix.
	cin.get();
	finalMessage(final_int_matrix, final_char_matrix, SIZE, columns);

	return 0;
}

void inputMessage(string& message, int& length)
{
	cout << "Type in your message to encode:\n";
	getline(cin, message);
	length = message.length();
	cout << endl;
}

void standardizeMessage(int length, int& columns, string& message)
{
	columns = length/3;
	if (length % 3 > 0)
	{
		columns++;
		int extra = 3 - (length % 3);
		for (int i=0; i < extra; i++)
			message += " ";
	}
}

void characterMatrix(vector<vector<char> >& char_matrix, string message, int columns)
{
	cout << "Plain Text Matrix:\n";
	int count=0;
	for (int col=0; col < columns; col++)
	{
		for (int row=0; row < 3; row++)
		{
			char_matrix[row][col] = message[count];
			count++;
		}
	}
	// outputs the char_matrix, need to throw this in a function
	for (int row=0; row < 3; row++)
	{
		cout << "[";
		for (int col=0; col < columns; col++)
			cout << setw(2) << char_matrix[row][col];
		cout << " ]" << endl;
	}
	cout << "\n\n";
}

void integerMatrix(vector<vector<double> >& int_matrix, string message, int columns)
{
	cout << "Plain Text Matrix converted into a number Matrix:\n";
	int count=0;
	for (int col=0; col < columns; col++)
	{
		for (int row=0; row < 3; row++)
		{
			int number = static_cast<int>(message[count]);
			number = static_cast<double>(number);
			int_matrix[row][col] = number;
			count++;
		}
	}
	// outputs the int_matrix, need to throw this in a function
	for (int row=0; row < 3; row++)
	{
		cout << "[";
		for (int col=0; col < columns; col++)
			cout << setw(4) << int_matrix[row][col];
		cout << " ]" << endl;
	}
	cout << "\n\n";
}

void encodingMatrix(double encoder[][3], int size)
{
	cout << "Cipher (Encoding Matrix):\n";
	for (int i=0; i<size; i++)  // size=3.
	{
		for (int j=0; j<size; j++)
		{
			int temp = rand() % 10;
			encoder[i][j] = static_cast<double>(temp);
		}
	}

	// Printing out encoding 3x3 matrix
	for (int row=0; row < size; row++)
	{
		cout << "[";
		for (int col=0; col < size; col++)
			cout << setw(2) << encoder[row][col];
		cout << " ]" << endl;
	}
	cout << "\n\n";
}

void encryptMatrix(vector<vector<double> >& resultantMatrix, vector<vector<double> >& startingMatrix, double coder[][3], int size, int columns)
{
	// Multiplies the encoder Matrix by the int_matrix and saves the products in the secrets matrix (the encrypted matrix).
	for (int row=0; row < size; row++)
	{
		for (int col=0; col < columns; col++)
			resultantMatrix[row][col] = (coder[row][0] * startingMatrix[0][col]) + (coder[row][1] * startingMatrix[1][col]) + (coder[row][2] * startingMatrix[2][col]);
	}
	// Outputs the encrypted matrix.
	cout << "CipherText (Encryption Pattern) Complete:\n";
	for (int row=0; row < 3; row++)
	{
		cout << "[";
		for (int col=0; col < columns; col++)
			cout << setw(5) << resultantMatrix[row][col];
		cout << " ]" << endl;
	}
	cout << "\n\n";

	///////////////////////////////////////////////////////////
	//This block of code between comment dashes was added to produce an encrypted character message to output. Most of the code here is taken from other functions already written. Since its last minute it is slightly buggy so its commented out for now.

	//converting ciphertext into encrypted alphabet message.
/*	vector <vector<int> > temp_int_Matrix(3, vector<int>(columns));

	for (int row=0; row < size; row++)
	{
		for (int col=0; col < columns; col++)
		{
			resultantMatrix[row][col] /= 5;
			if (ceil(resultantMatrix[row][col]) - resultantMatrix[row][col] < 0.1)
				resultantMatrix[row][col] = ceil(resultantMatrix[row][col]);

			temp_int_Matrix[row][col] = static_cast<int>(resultantMatrix[row][col]);
			//resultantMatrix[row][col] = static_cast<int>(resultantMatrix[row][col]);
		}
	}

	// copied from finalMessage function code:
	vector<vector<char> > charScramble(3, vector<char>(columns));

	string decodedMessage;	// string to hold the final message.
	int count=0;	// used as a counter for the string decodedMessage.
	
	for (int col=0; col < columns; col++)
	{
		for (int row=0; row < size; row++)
		{
			char letter = static_cast<char>(temp_int_Matrix[row][col]);
			charScramble[row][col] = letter;
			decodedMessage += charScramble[row][col];
			count++;
		}
	}

	// Outputs the character matrix.
	cin.get();
	cout << "Encrypted Plain Text Matrix:\n";
	for (int row=0; row < 3; row++)
	{
		cout << "[";
		for (int col=0; col < columns; col++)
			cout << setw(2) << charScramble[row][col];
		cout << " ]" << endl << endl;
	}
	
	cin.get();
	cout << "Encrypted Plain Text Message:    ";
	for (int col=0; col < columns; col++)
	{
		for (int row=0; row < size; row++)
		{
			cout << charScramble[row][col];
			resultantMatrix[row][col] *= 5;
		}
	}
	cout << "\n\n";
*/
	//////////////////////////////////////////////////////////


	// zero out the int_matrix.
	for (int row=0; row < 3; row++)
	{
		for (int col=0; col < columns; col++)
			startingMatrix[row][col]=0;
	}
}

void decodingMatrix(double decoder[][3], double encoder[][3], int size)
{
	double identity[3][3]={1.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,1.0};	// Declaring the identity matrix

	for (int step=0; step < size; step++) // step variable represents getting each column in upper triangular form. So the loop increments through each column putting them in that form.
	{
	// Checking for 0's along the major diagonal of the encoder matrix
		if (encoder[0+step][0+step] == 0)
		{
			for (int row=(1+step); row < size; row++)	// loops through row excluding the first row
			{
				if (encoder[row][0+step] != 0)	// if the matrix element checked is not zero then the chosen rows will be switched
				{
					for (int col=0; col < size; col++)	// loops through the columns to switch each element of the row
					{											// switching rows
						double temp = encoder[row][col];			// save matrix element in the latter row into a temporary variable.
						encoder[row][col] = encoder[0+step][col];	// the element of the first row is saved in the latter row.
						encoder[0+step][col] = temp;					// the element of the latter row is saved as a first row element.
					// Do the same thing for the Identity Matrix:
						temp = identity[row][col];
						identity[row][col] = identity[0+step][col];
						identity[0+step][col] = temp;
					}
					break;
				}
			}
		}
		// Check to see if the element in the major diagonal is one. If not then divide the whole row by whatever number is in that element of the array.
		if (encoder[0+step][0+step] != 1)
		{
			double scalar = encoder[0+step][0+step];	// Saves the current number in the current major diagonal element as the variable scalar to divide the whole row by.
			for (int col=0; col < size; col++)
			{
				encoder[0+step][col] = encoder[0+step][col] / scalar;
				identity[0+step][col] = identity[0+step][col] / scalar;	// Dividing the row in the identity matrix by the first element in the encoder matrix.
			}
		}
		// Check to see if all the elements directly below the first element in the matrix are zero, if not use row operations to make them zero.
		for (int row=(1+step); row < size; row++)
		{
			if (encoder[row][0+step] != 0)	// if the element is not zero run this block of code...
			{
				double scalar = encoder[row][0+step]; // Saves the number in the element below the current major diagonal as the variable scalar to be used to zero out that number.
				for (int col=0; col < size; col++)	// loop through each column of the marked row and do the row operations on the entire row
				{
					encoder[row][col] += (-(scalar))*(encoder[0+step][col]);	// Row operation
				// Do the same thing to the identity matrix
					identity[row][col] += (-(scalar))*(identity[0+step][col]);
				}
			}
		}
	}
	
	// Check to see if all the elements directly above the major diagonal element in the matrix are zero, if not use row operations to make them zero.
	for (int step = 1; step < size; step++)
	{
		for (int row=(size-(step+1)); row >= 0; row--)
		{
			if (encoder[row][size-step] != 0)	// if the element is not zero run this block of code...
			{
				double scalar = encoder[row][size-step]; // Saves the number in the element above the current major diagonal as the variable scalar to be used to zero out that number.
				for (int col=0; col < size; col++)	// loop through each column of the marked row and do the row operations on the entire row
				{
					encoder[row][col] += (-(scalar))*(encoder[size-step][col]);	// Row operation
				// Do the same thing to the identity matrix
					identity[row][col] += (-(scalar))*(identity[size-step][col]);
				}
			}
		}
	}


	// sets the decoder matrix to the transformed identity matrix, which is now the inverse of the encoder matrix.
	for (int row=0; row < size; row++)
	{
		for (int col=0; col < size; col++)
			decoder[row][col] = identity[row][col];
	}

	// Printing out the encoder matrix (which is now the identity) and the decoder matrix (which is the inverse of the original encoder).
	cout.setf(ios::fixed);	//To start outputting decimals in the matrices
	cout.setf(ios::showpoint);
	cout.precision(1);
	
	cout << "Finding Inverse of Cipher...\n";
	cin.get();

	cout << "\nFinal state of Cipher matrix (the Identity):\n";
	for (int row=0; row < size; row++)
	{
		cout.precision(2);
		cout << "[";
		for (int col=0; col < size; col++)
		{
			if (encoder[row][col]==-0)	// gets rid of negative signs on zeros
				encoder[row][col] = 0;
			cout << setw(6) << encoder[row][col];
		}
		cout << "  ]" << endl;
	}
	cout << "\n\n";

	cout << "\nDeciphering Key - Final state of decoder matrix (the inverse of the encoder):\n";
	for (int row=0; row < size; row++)
	{
		cout << "[";
		for (int col=0; col < size; col++)
			cout << setw(6) << decoder[row][col];
		cout << "  ]" << endl;
	}
	cout << "\n\n";
}

vector <vector<int> > decryptMatrix(vector<vector<double> >& resultantMatrix, vector<vector<double> > startingMatrix, double coder[][SIZE], int size, int columns)
{
	vector <vector<int> > temp_int_Matrix(3, vector<int>(columns));
	// Multiplies the decoder Matrix by the secrets(encrypted) matrix and saves the products in the int_matrix matrix (the unencrypted matrix).
	for (int row=0; row < size; row++)
	{
		for (int col=0; col < columns; col++)
			resultantMatrix[row][col] = (coder[row][0] * startingMatrix[0][col]) + (coder[row][1] * startingMatrix[1][col]) + (coder[row][2] * startingMatrix[2][col]);
	}

	//Converts the int_matrix (resultantMatrix) from floating-point numbers to integers.
	for (int col=0; col < columns; col++)
	{
		for (int row=0; row < 3; row++)
		{
			if (ceil(resultantMatrix[row][col]) - resultantMatrix[row][col] < 0.1)
				resultantMatrix[row][col] = ceil(resultantMatrix[row][col]);

			temp_int_Matrix[row][col] = static_cast<int>(resultantMatrix[row][col]);
		}
	}

	// Outputs the decrypted matrix.
	cout << "Decryption Pattern Complete:\n";
	for (int row=0; row < 3; row++)
	{
		cout << "[";
		for (int col=0; col < columns; col++)
			cout << setw(4) << temp_int_Matrix[row][col];
		cout << " ]" << endl;
	}
	cout << "\n\n";

	return temp_int_Matrix;
}

void finalMessage(vector<vector<int> > int_matrix, vector<vector<char> > char_matrix, int size, int columns)
{
	string decodedMessage;	// string to hold the final message.
	int count=0;	// used as a counter for the string decodedMessage.
	
	for (int col=0; col < columns; col++)
	{
		for (int row=0; row < size; row++)
		{
			char letter = static_cast<char>(int_matrix[row][col]);
			char_matrix[row][col] = letter;
			decodedMessage += char_matrix[row][col];
			count++;
		}
	}

	// Outputs the character matrix.
	cout << "Plain Text Matrix Deciphered:\n";
	for (int row=0; row < 3; row++)
	{
		cout << "[";
		for (int col=0; col < columns; col++)
			cout << setw(2) << char_matrix[row][col];
		cout << " ]" << endl;
	}
	cout << "\n\n";
	cout << "Decoded Message:\n\n" << decodedMessage << "\n\n";
}