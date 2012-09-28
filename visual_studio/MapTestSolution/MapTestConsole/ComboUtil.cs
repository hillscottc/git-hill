using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MapTestConsole
{

    public static class ComboUtil
    {
        /// <summary>
        /// Get all combinations (not ordered permutations) for an array of ints. 
        /// </summary>
        /// <param name="numbers"></param>
        /// <param name="n">number of ints in each returned combo</param>
        /// <returns>List of int[n] arrays.</returns>
        public static IEnumerable<int[]> GetCombinations(int[] numbers, int n)
        {
            return GetCombinations(numbers, 0, n);
        }


        private static IEnumerable<int[]> GetCombinations(int[] numbers, int start, int size)
        {
            if (size == 1)
            {
                for (int i = start; i < numbers.Length; ++i) yield return new[] { numbers[i] };
            }
            else
            {
                for (int i = start; i < numbers.Length; ++i)
                {
                    foreach (var a in GetCombinations(numbers, i + 1, size - 1))
                    {
                        yield return new[] { numbers[i] }.Concat(a).ToArray();
                    }
                }
            }
        }
    }
}
