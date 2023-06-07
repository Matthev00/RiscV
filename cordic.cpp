#include <iostream>
#include <cmath>
using namespace std;

const int num_iter = 20;

void cordic(double theta, double& s, double& c) {
    double cordic_ctab[num_iter] = {
        0.7071067811865476, 0.6324555320336759, 0.6135719910778963,
        0.6088339125177524, 0.6076482562561682, 0.6073517701412959,
        0.6072776440935250, 0.6072591122988927, 0.6072544793325624,
        0.6072533210898751, 0.6072530315291343, 0.6072529591389449,
        0.6072529410413971, 0.6072529365170102, 0.6072529353859135,
        0.6072529351031393, 0.6072529350324458, 0.6072529350147724,
        0.6072529350103540, 0.6072529350092495
    };
    double cordic_sintab[num_iter] = {
        0.7071067811865475, 0.7745966692414834, 0.7956547115901105,
        0.8017519097525161, 0.8037389576103663, 0.8043948315288164,
        0.8045896826784607, 0.8046479277693557, 0.8046657095728641,
        0.8046702824608796, 0.8046714579778887, 0.8046717018832219,
        0.8046717600541505, 0.8046717733795417, 0.8046717761564661,
        0.8046717767926286, 0.8046717769516718, 0.8046717769853517,
        0.8046717769919165, 0.8046717769935165
    };
    double x = cordic_ctab[0];
    double y = 0.0;
    double z = theta;
    double factor = 1.0;
    int k = 0;
    for (int i = 0; i < num_iter; i++) {
        double tx = x - factor*y;
        double ty = y + factor*x;
        double tz = z - factor*cordic_ctab[k];
        x = tx;
        y = ty;
        z = tz;
        factor /= 2.0;
        k++;
    }
    s = y;
    c = x;
}

int main() {
    double theta;
    cout << "Podaj kat w radianach: ";
    cin >> theta;
    double s, c;
    cordic(theta, s, c);
    cout << "sin(" << theta << ") = " << s << endl;
    cout << "cos(" << theta << ") = " << c << endl;
    return 0;
}
